----------------------------------------------------------------
-- GAME DEF : Quake I
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006-2009 Andrew Apted
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


QUAKE1_THINGS =
{
  -- players
  player1 = { id="info_player_start", kind="other", r=16,h=56 },
  player2 = { id="info_player_coop",  kind="other", r=16,h=56 },
  player3 = { id="info_player_coop",  kind="other", r=16,h=56 },
  player4 = { id="info_player_coop",  kind="other", r=16,h=56 },

  dm_player = { id="info_player_deathmatch", kind="other", r=16,h=56 },

  -- enemies
  dog      = { id="monster_dog",      kind="monster", r=32, h=80, },
  grunt    = { id="monster_army",     kind="monster", r=32, h=80, },
  enforcer = { id="monster_enforcer", kind="monster", r=32, h=80, },
  fiend    = { id="monster_demon1",   kind="monster", r=32, h=80, },

  knight   = { id="monster_knight",   kind="monster", r=32, h=80, },
  hell_knt = { id="monster_hell_knight", kind="monster", r=32, h=80, },
  ogre     = { id="monster_ogre",     kind="monster", r=32, h=80, },
  fish     = { id="monster_fish",     kind="monster", r=32, h=80, },
  scrag    = { id="monster_wizard",   kind="monster", r=32, h=80, },

  shambler = { id="monster_shambler", kind="monster", r=32, h=80, },
  spawn    = { id="monster_tarbaby",  kind="monster", r=32, h=80, },
  vore     = { id="monster_shalrath", kind="monster", r=32, h=80, },
  zombie   = { id="monster_zombie",   kind="monster", r=32, h=80, },

  -- bosses
  Chthon   = { id="monster_boss",   kind="monster", r=32, h=80, },
  Shub     = { id="monster_oldone", kind="monster", r=32, h=80, },

  -- pickups
  k_silver = { id="item_key1", kind="pickup", r=30, h=30, pass=true },
  k_gold   = { id="item_key2", kind="pickup", r=30, h=30, pass=true },

  ssg      = { id="weapon_supershotgun",    kind="pickup", r=30, h=30, pass=true },
  grenade  = { id="weapon_grenadelauncher", kind="pickup", r=30, h=30, pass=true },
  rocket   = { id="weapon_rocketlauncher",  kind="pickup", r=30, h=30, pass=true },
  nailgun  = { id="weapon_nailgun",         kind="pickup", r=30, h=30, pass=true },
  nailgun2 = { id="weapon_supernailgun",    kind="pickup", r=30, h=30, pass=true },
  zapper   = { id="weapon_lightning",       kind="pickup", r=30, h=30, pass=true },

  heal_25 = { id="item_health", spawnflags=0, kind="pickup", r=30, h=30, pass=true },
  heal_10 = { id="item_health", spawnflags=1, kind="pickup", r=30, h=30, pass=true },
  mega    = { id="item_health", spawnflags=2, kind="pickup", r=30, h=30, pass=true },

  green_armor  = { id="item_armor1",   kind="pickup", r=30, h=30, pass=true },
  yellow_armor = { id="item_armor2",   kind="pickup", r=30, h=30, pass=true },
  red_armor    = { id="item_armorInv", kind="pickup", r=30, h=30, pass=true },

  shell_20  = { id="item_shells",  spawnflags=0, kind="pickup", r=30, h=30, pass=true },
  shell_40  = { id="item_shells",  spawnflags=1, kind="pickup", r=30, h=30, pass=true },
  nail_25   = { id="item_spikes",  spawnflags=0, kind="pickup", r=30, h=30, pass=true },
  nail_50   = { id="item_spikes",  spawnflags=1, kind="pickup", r=30, h=30, pass=true },
  rocket_5  = { id="item_rockets", spawnflags=0, kind="pickup", r=30, h=30, pass=true },
  rocket_10 = { id="item_rockets", spawnflags=1, kind="pickup", r=30, h=30, pass=true },
  cell_6    = { id="item_cells",   spawnflags=0, kind="pickup", r=30, h=30, pass=true },
  cell_12   = { id="item_cells",   spawnflags=1, kind="pickup", r=30, h=30, pass=true },

  suit   = { id="item_artifact_envirosuit",      kind="pickup", r=30, h=30, pass=true },
  invis  = { id="item_artifact_invisibility",    kind="pickup", r=30, h=30, pass=true },
  invuln = { id="item_artifact_invulnerability", kind="pickup", r=30, h=30, pass=true },
  quad   = { id="item_artifact_super_damage",    kind="pickup", r=30, h=30, pass=true },

  -- scenery
  explode_sm = { id="misc_explobox2", kind="scenery", r=30, h=80, },
  explode_bg = { id="misc_explobox2", kind="scenery", r=30, h=40, },

  crucified  = { id="monster_zombie", spawnflags=1, kind="scenery", r=32, h=64, },
  torch      = { id="light_torch_small_walltorch",  kind="scenery", r=30, h=60, pass=true },

  -- ambient sounds
  snd_computer = { id="ambient_comp_hum",  kind="scenery", r=30, h=30, pass=true },
  snd_drip     = { id="ambient_drip",      kind="scenery", r=30, h=30, pass=true },
  snd_drone    = { id="ambient_drone",     kind="scenery", r=30, h=30, pass=true },
  snd_wind     = { id="ambient_suck_wind", kind="scenery", r=30, h=30, pass=true },
  snd_swamp1   = { id="ambient_swamp1",    kind="scenery", r=30, h=30, pass=true },
  snd_swamp2   = { id="ambient_swamp2",    kind="scenery", r=30, h=30, pass=true },

  -- special

}


----------------------------------------------------------------

QUAKE1_PALETTE =
{
    0,  0,  0,  15, 15, 15,  31, 31, 31,  47, 47, 47,  63, 63, 63,
   75, 75, 75,  91, 91, 91, 107,107,107, 123,123,123, 139,139,139,
  155,155,155, 171,171,171, 187,187,187, 203,203,203, 219,219,219,
  235,235,235,  15, 11,  7,  23, 15, 11,  31, 23, 11,  39, 27, 15,
   47, 35, 19,  55, 43, 23,  63, 47, 23,  75, 55, 27,  83, 59, 27,
   91, 67, 31,  99, 75, 31, 107, 83, 31, 115, 87, 31, 123, 95, 35,
  131,103, 35, 143,111, 35,  11, 11, 15,  19, 19, 27,  27, 27, 39,
   39, 39, 51,  47, 47, 63,  55, 55, 75,  63, 63, 87,  71, 71,103,
   79, 79,115,  91, 91,127,  99, 99,139, 107,107,151, 115,115,163,
  123,123,175, 131,131,187, 139,139,203,   0,  0,  0,   7,  7,  0,
   11, 11,  0,  19, 19,  0,  27, 27,  0,  35, 35,  0,  43, 43,  7,
   47, 47,  7,  55, 55,  7,  63, 63,  7,  71, 71,  7,  75, 75, 11,
   83, 83, 11,  91, 91, 11,  99, 99, 11, 107,107, 15,   7,  0,  0,
   15,  0,  0,  23,  0,  0,  31,  0,  0,  39,  0,  0,  47,  0,  0,
   55,  0,  0,  63,  0,  0,  71,  0,  0,  79,  0,  0,  87,  0,  0,
   95,  0,  0, 103,  0,  0, 111,  0,  0, 119,  0,  0, 127,  0,  0,
   19, 19,  0,  27, 27,  0,  35, 35,  0,  47, 43,  0,  55, 47,  0,
   67, 55,  0,  75, 59,  7,  87, 67,  7,  95, 71,  7, 107, 75, 11,
  119, 83, 15, 131, 87, 19, 139, 91, 19, 151, 95, 27, 163, 99, 31,
  175,103, 35,  35, 19,  7,  47, 23, 11,  59, 31, 15,  75, 35, 19,
   87, 43, 23,  99, 47, 31, 115, 55, 35, 127, 59, 43, 143, 67, 51,
  159, 79, 51, 175, 99, 47, 191,119, 47, 207,143, 43, 223,171, 39,
  239,203, 31, 255,243, 27,  11,  7,  0,  27, 19,  0,  43, 35, 15,
   55, 43, 19,  71, 51, 27,  83, 55, 35,  99, 63, 43, 111, 71, 51,
  127, 83, 63, 139, 95, 71, 155,107, 83, 167,123, 95, 183,135,107,
  195,147,123, 211,163,139, 227,179,151, 171,139,163, 159,127,151,
  147,115,135, 139,103,123, 127, 91,111, 119, 83, 99, 107, 75, 87,
   95, 63, 75,  87, 55, 67,  75, 47, 55,  67, 39, 47,  55, 31, 35,
   43, 23, 27,  35, 19, 19,  23, 11, 11,  15,  7,  7, 187,115,159,
  175,107,143, 163, 95,131, 151, 87,119, 139, 79,107, 127, 75, 95,
  115, 67, 83, 107, 59, 75,  95, 51, 63,  83, 43, 55,  71, 35, 43,
   59, 31, 35,  47, 23, 27,  35, 19, 19,  23, 11, 11,  15,  7,  7,
  219,195,187, 203,179,167, 191,163,155, 175,151,139, 163,135,123,
  151,123,111, 135,111, 95, 123, 99, 83, 107, 87, 71,  95, 75, 59,
   83, 63, 51,  67, 51, 39,  55, 43, 31,  39, 31, 23,  27, 19, 15,
   15, 11,  7, 111,131,123, 103,123,111,  95,115,103,  87,107, 95,
   79, 99, 87,  71, 91, 79,  63, 83, 71,  55, 75, 63,  47, 67, 55,
   43, 59, 47,  35, 51, 39,  31, 43, 31,  23, 35, 23,  15, 27, 19,
   11, 19, 11,   7, 11,  7, 255,243, 27, 239,223, 23, 219,203, 19,
  203,183, 15, 187,167, 15, 171,151, 11, 155,131,  7, 139,115,  7,
  123, 99,  7, 107, 83,  0,  91, 71,  0,  75, 55,  0,  59, 43,  0,
   43, 31,  0,  27, 15,  0,  11,  7,  0,   0,  0,255,  11, 11,239,
   19, 19,223,  27, 27,207,  35, 35,191,  43, 43,175,  47, 47,159,
   47, 47,143,  47, 47,127,  47, 47,111,  47, 47, 95,  43, 43, 79,
   35, 35, 63,  27, 27, 47,  19, 19, 31,  11, 11, 15,  43,  0,  0,
   59,  0,  0,  75,  7,  0,  95,  7,  0, 111, 15,  0, 127, 23,  7,
  147, 31,  7, 163, 39, 11, 183, 51, 15, 195, 75, 27, 207, 99, 43,
  219,127, 59, 227,151, 79, 231,171, 95, 239,191,119, 247,211,139,
  167,123, 59, 183,155, 55, 199,195, 55, 231,227, 87, 127,191,255,
  171,231,255, 215,255,255, 103,  0,  0, 139,  0,  0, 179,  0,  0,
  215,  0,  0, 255,  0,  0, 255,243,147, 255,247,199, 255,255,255,
  159, 91, 83
}


----------------------------------------------------------------

QUAKE1_MATERIALS =
{
  ADOOR01_2  = { "adoor01_2" },
  ADOOR02_2  = { "adoor02_2" },
  ADOOR03_2  = { "adoor03_2" },
  ADOOR03_3  = { "adoor03_3" },
  ADOOR03_4  = { "adoor03_4" },
  ADOOR03_5  = { "adoor03_5" },
  ADOOR03_6  = { "adoor03_6" },
  ADOOR09_1  = { "adoor09_1" },
  ADOOR09_2  = { "adoor09_2" },
  AFLOOR1_3  = { "afloor1_3" },
  AFLOOR1_4  = { "afloor1_4" },
  AFLOOR1_8  = { "afloor1_8" },
  AFLOOR3_1  = { "afloor3_1" },
  ALTAR1_1   = { "altar1_1" },
  ALTAR1_3   = { "altar1_3" },
  ALTAR1_4   = { "altar1_4" },
  ALTAR1_6   = { "altar1_6" },
  ALTAR1_7   = { "altar1_7" },
  ALTAR1_8   = { "altar1_8" },
  ALTARB_1   = { "altarb_1" },
  ALTARB_2   = { "altarb_2" },
  ALTARC_1   = { "altarc_1" },
  ARCH7      = { "arch7" },
  ARROW_M    = { "arrow_m" },
  AZ1_6      = { "az1_6" },
  AZFLOOR1_1 = { "azfloor1_1" },
  AZSWITCH3  = { "azswitch3" },
  AZWALL1_5  = { "azwall1_5" },
  AZWALL3_1  = { "azwall3_1" },
  AZWALL3_2  = { "azwall3_2" },
  BASEBUTN3  = { "basebutn3" },
  BLACK      = { "black" },
  BODIESA2_1 = { "bodiesa2_1" },
  BODIESA2_4 = { "bodiesa2_4" },
  BODIESA3_1 = { "bodiesa3_1" },
  BODIESA3_2 = { "bodiesa3_2" },
  BODIESA3_3 = { "bodiesa3_3" },
  BRICKA2_1  = { "bricka2_1" },
  BRICKA2_2  = { "bricka2_2" },
  BRICKA2_4  = { "bricka2_4" },
  BRICKA2_6  = { "bricka2_6" },
  CARCH02    = { "carch02" },
  CARCH03    = { "carch03" },
  CARCH04_1  = { "carch04_1" },
  CARCH04_2  = { "carch04_2" },
  CEIL1_1    = { "ceil1_1" },
  CEILING1_3 = { "ceiling1_3" },
  CEILING4   = { "ceiling4" },
  CEILING5   = { "ceiling5" },
  CHURCH1_2  = { "church1_2" },
  CHURCH7    = { "church7" },

  CITY1_4    = { "city1_4" },
  CITY1_7    = { "city1_7" },
  CITY2_1    = { "city2_1" },
  CITY2_2    = { "city2_2" },
  CITY2_3    = { "city2_3" },
  CITY2_5    = { "city2_5" },
  CITY2_6    = { "city2_6" },
  CITY2_7    = { "city2_7" },
  CITY2_8    = { "city2_8" },
  CITY3_2    = { "city3_2" },
  CITY3_4    = { "city3_4" },
  CITY4_1    = { "city4_1" },
  CITY4_2    = { "city4_2" },
  CITY4_5    = { "city4_5" },
  CITY4_6    = { "city4_6" },
  CITY4_7    = { "city4_7" },
  CITY4_8    = { "city4_8" },
  CITY5_1    = { "city5_1" },
  CITY5_2    = { "city5_2" },
  CITY5_3    = { "city5_3" },
  CITY5_4    = { "city5_4" },
  CITY5_6    = { "city5_6" },
  CITY5_7    = { "city5_7" },
  CITY5_8    = { "city5_8" },
  CITY6_3    = { "city6_3" },
  CITY6_4    = { "city6_4" },
  CITY6_7    = { "city6_7" },
  CITY6_8    = { "city6_8" },
  CITY8_2    = { "city8_2" },
  CITYA1_1   = { "citya1_1" },
  CLIP       = { "clip" },
  COLUMN01_3 = { "column01_3" },
  COLUMN01_4 = { "column01_4" },
  COLUMN1_2  = { "column1_2" },
  COLUMN1_4  = { "column1_4" },
  COLUMN1_5  = { "column1_5" },
  COMP1_1    = { "comp1_1" },
  COMP1_2    = { "comp1_2" },
  COMP1_3    = { "comp1_3" },
  COMP1_4    = { "comp1_4" },
  COMP1_5    = { "comp1_5" },
  COMP1_6    = { "comp1_6" },
  COMP1_7    = { "comp1_7" },
  COMP1_8    = { "comp1_8" },
  COP1_1     = { "cop1_1" },
  COP1_2     = { "cop1_2" },
  COP1_3     = { "cop1_3" },
  COP1_4     = { "cop1_4" },
  COP1_5     = { "cop1_5" },
  COP1_6     = { "cop1_6" },
  COP1_7     = { "cop1_7" },
  COP1_8     = { "cop1_8" },
  COP2_1     = { "cop2_1" },
  COP2_2     = { "cop2_2" },
  COP2_3     = { "cop2_3" },
  COP2_4     = { "cop2_4" },
  COP2_5     = { "cop2_5" },
  COP2_6     = { "cop2_6" },
  COP3_1     = { "cop3_1" },
  COP3_2     = { "cop3_2" },
  COP3_4     = { "cop3_4" },
  COP4_3     = { "cop4_3" },
  COP4_5     = { "cop4_5" },

  CRATE0_SIDE = { "crate0_side" },
  CRATE0_TOP  = { "crate0_top" },
  CRATE1_SIDE = { "crate1_side" },
  CRATE1_TOP  = { "crate1_top" },
  DEM4_1     = { "dem4_1" },
  DEM4_4     = { "dem4_4" },
  DEM5_3     = { "dem5_3" },
  DEMC4_4    = { "demc4_4" },
  DOOR01_2   = { "door01_2" },
  DOOR02_1   = { "door02_1" },
  DOOR02_2   = { "door02_2" },
  DOOR02_3   = { "door02_3" },
  DOOR02_7   = { "door02_7" },
  DOOR03_2   = { "door03_2" },
  DOOR03_3   = { "door03_3" },
  DOOR03_4   = { "door03_4" },
  DOOR03_5   = { "door03_5" },
  DOOR04_1   = { "door04_1" },
  DOOR04_2   = { "door04_2" },
  DOOR05_2   = { "door05_2" },
  DOOR05_3   = { "door05_3" },
  DOPEBACK   = { "dopeback" },
  DOPEFISH   = { "dopefish" },
  DR01_1     = { "dr01_1" },
  DR01_2     = { "dr01_2" },
  DR02_1     = { "dr02_1" },
  DR02_2     = { "dr02_2" },
  DR03_1     = { "dr03_1" },
  DR05_2     = { "dr05_2" },
  DR07_1     = { "dr07_1" },
  DUNG01_1   = { "dung01_1" },
  DUNG01_2   = { "dung01_2" },
  DUNG01_3   = { "dung01_3" },
  DUNG01_4   = { "dung01_4" },
  DUNG01_5   = { "dung01_5" },
  DUNG02_1   = { "dung02_1" },
  DUNG02_5   = { "dung02_5" },
  ECOP1_1    = { "ecop1_1" },
  ECOP1_4    = { "ecop1_4" },
  ECOP1_6    = { "ecop1_6" },
  ECOP1_7    = { "ecop1_7" },
  ECOP1_8    = { "ecop1_8" },
  EDOOR01_1  = { "edoor01_1" },
  ELWALL1_1  = { "elwall1_1" },
  ELWALL2_4  = { "elwall2_4" },
  EMETAL1_3  = { "emetal1_3" },
  ENTER01    = { "enter01" },
  EXIT01     = { "exit01" },
  EXIT02_2   = { "exit02_2" },
  EXIT02_3   = { "exit02_3" },
  FLOOR01_5  = { "floor01_5" },

  GRAVE01_1  = { "grave01_1" },
  GRAVE01_3  = { "grave01_3" },
  GRAVE02_1  = { "grave02_1" },
  GRAVE02_2  = { "grave02_2" },
  GRAVE02_3  = { "grave02_3" },
  GRAVE02_4  = { "grave02_4" },
  GRAVE02_5  = { "grave02_5" },
  GRAVE02_6  = { "grave02_6" },
  GRAVE02_7  = { "grave02_7" },
  GRAVE03_1  = { "grave03_1" },
  GRAVE03_2  = { "grave03_2" },
  GRAVE03_3  = { "grave03_3" },
  GRAVE03_4  = { "grave03_4" },
  GRAVE03_5  = { "grave03_5" },
  GRAVE03_6  = { "grave03_6" },
  GRAVE03_7  = { "grave03_7" },
  GROUND1_1  = { "ground1_1" },
  GROUND1_2  = { "ground1_2" },
  GROUND1_5  = { "ground1_5" },
  GROUND1_6  = { "ground1_6" },
  GROUND1_7  = { "ground1_7" },
  GROUND1_8  = { "ground1_8" },
  KEY01_1    = { "key01_1" },
  KEY01_2    = { "key01_2" },
  KEY01_3    = { "key01_3" },
  KEY02_1    = { "key02_1" },
  KEY02_2    = { "key02_2" },
  KEY03_1    = { "key03_1" },
  KEY03_2    = { "key03_2" },
  KEY03_3    = { "key03_3" },
  LGMETAL    = { "lgmetal" },
  LGMETAL2   = { "lgmetal2" },
  LGMETAL3   = { "lgmetal3" },
  LGMETAL4   = { "lgmetal4" },
  LIGHT1_1   = { "light1_1" },
  LIGHT1_2   = { "light1_2" },
  LIGHT1_3   = { "light1_3" },
  LIGHT1_4   = { "light1_4" },
  LIGHT1_5   = { "light1_5" },
  LIGHT1_7   = { "light1_7" },
  LIGHT1_8   = { "light1_8" },
  LIGHT3_3   = { "light3_3" },
  LIGHT3_5   = { "light3_5" },
  LIGHT3_6   = { "light3_6" },
  LIGHT3_7   = { "light3_7" },
  LIGHT3_8   = { "light3_8" },

  M5_3       = { "m5_3" },
  M5_5       = { "m5_5" },
  M5_8       = { "m5_8" },
  MET5_1     = { "met5_1" },
  MET5_2     = { "met5_2" },
  MET5_3     = { "met5_3" },
  METAL1_1   = { "metal1_1" },
  METAL1_2   = { "metal1_2" },
  METAL1_3   = { "metal1_3" },
  METAL1_4   = { "metal1_4" },
  METAL1_5   = { "metal1_5" },
  METAL1_6   = { "metal1_6" },
  METAL1_7   = { "metal1_7" },
  METAL2_1   = { "metal2_1" },
  METAL2_2   = { "metal2_2" },
  METAL2_3   = { "metal2_3" },
  METAL2_4   = { "metal2_4" },
  METAL2_5   = { "metal2_5" },
  METAL2_6   = { "metal2_6" },
  METAL2_7   = { "metal2_7" },
  METAL2_8   = { "metal2_8" },
  METAL3_2   = { "metal3_2" },
  METAL4_2   = { "metal4_2" },
  METAL4_3   = { "metal4_3" },
  METAL4_4   = { "metal4_4" },
  METAL4_5   = { "metal4_5" },
  METAL4_6   = { "metal4_6" },
  METAL4_7   = { "metal4_7" },
  METAL4_8   = { "metal4_8" },
  METAL5_1   = { "metal5_1" },
  METAL5_2   = { "metal5_2" },
  METAL5_3   = { "metal5_3" },
  METAL5_4   = { "metal5_4" },
  METAL5_5   = { "metal5_5" },
  METAL5_6   = { "metal5_6" },
  METAL5_8   = { "metal5_8" },
  METAL6_1   = { "metal6_1" },
  METAL6_2   = { "metal6_2" },
  METAL6_3   = { "metal6_3" },
  METAL6_4   = { "metal6_4" },
  METALT1_1  = { "metalt1_1" },
  METALT1_2  = { "metalt1_2" },
  METALT1_7  = { "metalt1_7" },
  METALT2_1  = { "metalt2_1" },
  METALT2_2  = { "metalt2_2" },
  METALT2_3  = { "metalt2_3" },
  METALT2_4  = { "metalt2_4" },
  METALT2_5  = { "metalt2_5" },
  METALT2_6  = { "metalt2_6" },
  METALT2_7  = { "metalt2_7" },
  METALT2_8  = { "metalt2_8" },
  METFLOR2_1 = { "metflor2_1" },
  MMETAL1_1  = { "mmetal1_1" },
  MMETAL1_2  = { "mmetal1_2" },
  MMETAL1_3  = { "mmetal1_3" },
  MMETAL1_5  = { "mmetal1_5" },
  MMETAL1_6  = { "mmetal1_6" },
  MMETAL1_7  = { "mmetal1_7" },
  MMETAL1_8  = { "mmetal1_8" },
  MSWTCH_2   = { "mswtch_2" },
  MSWTCH_3   = { "mswtch_3" },
  MSWTCH_4   = { "mswtch_4" },
  MUH_BAD    = { "muh_bad" },
  NMETAL2_1  = { "nmetal2_1" },
  NMETAL2_6  = { "nmetal2_6" },
  PLAT_SIDE1 = { "plat_side1" },
  PLAT_STEM  = { "plat_stem" },
  PLAT_TOP1  = { "plat_top1" },
  PLAT_TOP2  = { "plat_top2" },

  QUAKE      = { "quake" },
  RAVEN      = { "raven" },
  ROCK1_2    = { "rock1_2" },
  ROCK3_2    = { "rock3_2" },
  ROCK3_7    = { "rock3_7" },
  ROCK3_8    = { "rock3_8" },
  ROCK4_1    = { "rock4_1" },
  ROCK4_2    = { "rock4_2" },
  ROCK5_2    = { "rock5_2" },
  RUNE1_1    = { "rune1_1" },
  RUNE1_4    = { "rune1_4" },
  RUNE1_5    = { "rune1_5" },
  RUNE1_6    = { "rune1_6" },
  RUNE1_7    = { "rune1_7" },
  RUNE2_1    = { "rune2_1" },
  RUNE2_2    = { "rune2_2" },
  RUNE2_3    = { "rune2_3" },
  RUNE2_4    = { "rune2_4" },
  RUNE2_5    = { "rune2_5" },
  RUNE_A     = { "rune_a" },
  SFLOOR1_2  = { "sfloor1_2" },
  SFLOOR3_2  = { "sfloor3_2" },
  SFLOOR4_1  = { "sfloor4_1" },
  SFLOOR4_2  = { "sfloor4_2" },
  SFLOOR4_4  = { "sfloor4_4" },
  SFLOOR4_5  = { "sfloor4_5" },
  SFLOOR4_6  = { "sfloor4_6" },
  SFLOOR4_7  = { "sfloor4_7" },
  SFLOOR4_8  = { "sfloor4_8" },
  SKILL0     = { "skill0" },
  SKILL1     = { "skill1" },
  SKILL2     = { "skill2" },
  SKILL3     = { "skill3" },
  SLIP1      = { "slip1" },
  SLIP2      = { "slip2" },
  SLIPBOTSD  = { "slipbotsd" },
  SLIPLITE   = { "sliplite" },
  SLIPSIDE   = { "slipside" },
  SLIPTOPSD  = { "sliptopsd" },
  STONE1_3   = { "stone1_3" },
  STONE1_5   = { "stone1_5" },
  STONE1_7   = { "stone1_7" },
  SWITCH_1   = { "switch_1" },
  SWTCH1_1   = { "swtch1_1" },

  TECH01_1   = { "tech01_1" },
  TECH01_2   = { "tech01_2" },
  TECH01_3   = { "tech01_3" },
  TECH01_5   = { "tech01_5" },
  TECH01_6   = { "tech01_6" },
  TECH01_7   = { "tech01_7" },
  TECH01_9   = { "tech01_9" },
  TECH02_1   = { "tech02_1" },
  TECH02_2   = { "tech02_2" },
  TECH02_3   = { "tech02_3" },
  TECH02_5   = { "tech02_5" },
  TECH02_6   = { "tech02_6" },
  TECH02_7   = { "tech02_7" },
  TECH03_1   = { "tech03_1" },
  TECH03_2   = { "tech03_2" },
  TECH04_1   = { "tech04_1" },
  TECH04_2   = { "tech04_2" },
  TECH04_3   = { "tech04_3" },
  TECH04_4   = { "tech04_4" },
  TECH04_5   = { "tech04_5" },
  TECH04_6   = { "tech04_6" },
  TECH04_7   = { "tech04_7" },
  TECH04_8   = { "tech04_8" },
  TECH05_1   = { "tech05_1" },
  TECH05_2   = { "tech05_2" },
  TECH06_1   = { "tech06_1" },
  TECH06_2   = { "tech06_2" },
  TECH07_1   = { "tech07_1" },
  TECH07_2   = { "tech07_2" },
  TECH08_1   = { "tech08_1" },
  TECH08_2   = { "tech08_2" },
  TECH09_3   = { "tech09_3" },
  TECH09_4   = { "tech09_4" },
  TECH10_1   = { "tech10_1" },
  TECH10_3   = { "tech10_3" },
  TECH11_1   = { "tech11_1" },
  TECH11_2   = { "tech11_2" },
  TECH12_1   = { "tech12_1" },
  TECH13_2   = { "tech13_2" },
  TECH14_1   = { "tech14_1" },
  TECH14_2   = { "tech14_2" },
  TELE_TOP   = { "tele_top" },
  TLIGHT01   = { "tlight01" },
  TLIGHT01_2 = { "tlight01_2" },
  TLIGHT02   = { "tlight02" },
  TLIGHT03   = { "tlight03" },
  TLIGHT05   = { "tlight05" },
  TLIGHT07   = { "tlight07" },
  TLIGHT08   = { "tlight08" },
  TLIGHT09   = { "tlight09" },
  TLIGHT10   = { "tlight10" },
  TLIGHT11   = { "tlight11" },
  TRIGGER    = { "trigger" },
  TWALL1_1   = { "twall1_1" },
  TWALL1_2   = { "twall1_2" },
  TWALL1_4   = { "twall1_4" },
  TWALL2_1   = { "twall2_1" },
  TWALL2_2   = { "twall2_2" },
  TWALL2_3   = { "twall2_3" },
  TWALL2_5   = { "twall2_5" },
  TWALL2_6   = { "twall2_6" },
  TWALL3_1   = { "twall3_1" },
  TWALL5_1   = { "twall5_1" },
  TWALL5_2   = { "twall5_2" },
  TWALL5_3   = { "twall5_3" },

  UNWALL1_8  = { "unwall1_8" },
  UWALL1_2   = { "uwall1_2" },
  UWALL1_3   = { "uwall1_3" },
  UWALL1_4   = { "uwall1_4" },
  VINE1_2    = { "vine1_2" },
  WALL11_2   = { "wall11_2" },
  WALL11_6   = { "wall11_6" },
  WALL14_5   = { "wall14_5" },
  WALL14_6   = { "wall14_6" },
  WALL16_7   = { "wall16_7" },
  WALL3_4    = { "wall3_4" },
  WALL5_4    = { "wall5_4" },
  WALL9_3    = { "wall9_3" },
  WALL9_8    = { "wall9_8" },
  WARCH05    = { "warch05" },
  WBRICK1_4  = { "wbrick1_4" },
  WBRICK1_5  = { "wbrick1_5" },
  WCEILING4  = { "wceiling4" },
  WCEILING5  = { "wceiling5" },
  WENTER01   = { "wenter01" },
  WEXIT01    = { "wexit01" },
  WGRASS1_1  = { "wgrass1_1" },
  WGRND1_5   = { "wgrnd1_5" },
  WGRND1_6   = { "wgrnd1_6" },
  WGRND1_8   = { "wgrnd1_8" },
  WINDOW01_1 = { "window01_1" },
  WINDOW01_2 = { "window01_2" },
  WINDOW01_3 = { "window01_3" },
  WINDOW01_4 = { "window01_4" },
  WINDOW02_1 = { "window02_1" },
  WINDOW03   = { "window03" },
  WINDOW1_2  = { "window1_2" },
  WINDOW1_3  = { "window1_3" },
  WINDOW1_4  = { "window1_4" },
  WIZ1_1     = { "wiz1_1" },
  WIZ1_4     = { "wiz1_4" },
  WIZMET1_1  = { "wizmet1_1" },
  WIZMET1_2  = { "wizmet1_2" },
  WIZMET1_3  = { "wizmet1_3" },
  WIZMET1_4  = { "wizmet1_4" },
  WIZMET1_5  = { "wizmet1_5" },
  WIZMET1_6  = { "wizmet1_6" },
  WIZMET1_7  = { "wizmet1_7" },
  WIZMET1_8  = { "wizmet1_8" },
  WIZWIN1_2  = { "wizwin1_2" },
  WIZWIN1_8  = { "wizwin1_8" },
  WIZWOOD1_2 = { "wizwood1_2" },
  WIZWOOD1_3 = { "wizwood1_3" },
  WIZWOOD1_4 = { "wizwood1_4" },
  WIZWOOD1_5 = { "wizwood1_5" },
  WIZWOOD1_6 = { "wizwood1_6" },
  WIZWOOD1_7 = { "wizwood1_7" },
  WIZWOOD1_8 = { "wizwood1_8" },
  WKEY02_1   = { "wkey02_1" },
  WKEY02_2   = { "wkey02_2" },
  WKEY02_3   = { "wkey02_3" },
  WMET1_1    = { "wmet1_1" },
  WMET2_1    = { "wmet2_1" },
  WMET2_2    = { "wmet2_2" },
  WMET2_3    = { "wmet2_3" },
  WMET2_4    = { "wmet2_4" },
  WMET2_6    = { "wmet2_6" },
  WMET3_1    = { "wmet3_1" },
  WMET3_3    = { "wmet3_3" },
  WMET3_4    = { "wmet3_4" },
  WMET4_2    = { "wmet4_2" },
  WMET4_3    = { "wmet4_3" },
  WMET4_4    = { "wmet4_4" },
  WMET4_5    = { "wmet4_5" },
  WMET4_6    = { "wmet4_6" },
  WMET4_7    = { "wmet4_7" },
  WMET4_8    = { "wmet4_8" },
  WOOD1_1    = { "wood1_1" },
  WOOD1_5    = { "wood1_5" },
  WOOD1_7    = { "wood1_7" },
  WOOD1_8    = { "wood1_8" },
  WOODFLR1_2 = { "woodflr1_2" },
  WOODFLR1_4 = { "woodflr1_4" },
  WOODFLR1_5 = { "woodflr1_5" },
  WSWAMP1_2  = { "wswamp1_2" },
  WSWAMP1_4  = { "wswamp1_4" },
  WSWAMP2_1  = { "wswamp2_1" },
  WSWAMP2_2  = { "wswamp2_2" },
  WSWITCH1   = { "wswitch1" },
  WWALL1_1   = { "wwall1_1" },
  WWOOD1_5   = { "wwood1_5" },
  WWOOD1_7   = { "wwood1_7" },
  Z_EXIT     = { "z_exit" },

---  +0basebtn
---  +0butn
---  +0butnn
---  +0button
---  +0floorsw
---  +0light01
---  +0mtlsw
---  +0planet
---  +0shoot
---  +0slip
---  +0slipbot
---  +0sliptop
---  +1basebtn
---  +1butn
---  +1butnn
---  +1button
---  +1floorsw
---  +1light01
---  +1mtlsw
---  +1planet
---  +1shoot
---  +1slip
---  +2butn
---  +2butnn
---  +2button
---  +2floorsw
---  +2light01
---  +2mtlsw
---  +2planet
---  +2shoot
---  +2slip
---  +3butn
---  +3butnn
---  +3button
---  +3floorsw
---  +3mtlsw
---  +3planet
---  +3shoot
---  +3slip
---  +4slip
---  +5slip
---  +6slip
---  +abasebtn
---  +abutn
---  +abutnn
---  +abutton
---  +afloorsw
---  +amtlsw
---  +ashoot

---  *lava1
---  *slime
---  *slime0
---  *slime1
---  *teleport
---  *water0
---  *water1
---  *water2
---  *04awater1
---  *04mwat1
---  *04mwat2
---  *04water1
---  *04water2
}


----------------------------------------------------------------

QUAKE1_COMBOS =
{
  TECH_BASE =
  {
    theme_probs = { TECH=80 },

    wall  = "tech05_2",
    floor = "metflor2_1",
    ceil  = "tlight09",
  },

  TECH_GROUND =
  {
    theme_probs = { TECH=80 },
    outdoor = true,

    wall  = "ground1_6",
    floor = "ground1_6",
    ceil  = "ground1_6",
  }
}

QUAKE1_EXITS =
{
  ELEVATOR =  -- FIXME: not needed, remove
  {
    mat_pri = 0,
    wall = 21, void = 21, floor=0, ceil=0,
  },
}


QUAKE1_KEY_DOORS =
{
  k_silver = { door_kind="door_silver", door_side=14 },
  k_gold   = { door_kind="door_gold",   door_side=14 },
}

QUAKE1_MISC_PREFABS =
{
  elevator =
  {
    prefab = "WOLF_ELEVATOR",
    add_mode = "extend",

    skin = { elevator=21, front=14, }
  },
}



---- QUEST STUFF ----------------

QUAKE1_QUESTS =
{
  key = { k_silver=60, k_gold=30, },

  switch = { },

  weapon = { machine_gun=50, gatling_gun=20, },

  item =
  {
    crown = 50, chest = 50, cross = 50, chalice = 50,
    one_up = 2,
  },

  exit =
  {
    elevator=50
  }
}


QUAKE1_ROOMS =
{
  PLAIN =
  {
  },

  HALLWAY =
  {
    scenery = { ceil_light=90 },

    space_range = { 10, 50 },
  },

  STORAGE =
  {
    scenery = { barrel=50, green_barrel=80, }
  },

  TREASURE =
  {
    pickups = { cross=90, chalice=90, chest=20, crown=5 },
    pickup_rate = 90,
  },

  SUPPLIES =
  {
    scenery = { barrel=70, bed=40, },

    pickups = { first_aid=50, good_food=90, clip_8=70 },
    pickup_rate = 66,
  },

  QUARTERS =
  {
    scenery = { table_chairs=70, bed=70, chandelier=70,
                bare_table=20, puddle=20,
                floor_lamp=10, urn=10, plant=10
              },
  },

  BATHROOM =
  {
    scenery = { sink=50, puddle=90, water_well=30, empty_well=30 },
  },

  KITCHEN =
  {
    scenery = { kitchen_stuff=50, stove=50, pots=50,
                puddle=20, bare_table=20, table_chairs=5,
                sink=10, barrel=10, green_barrel=5, plant=2
              },

    pickups = { good_food=15, dog_food=5 },
    pickup_rate = 20,
  },

  TORTURE =
  {
    scenery = { hanging_cage=80, skeleton_in_cage=80,
                skeleton_relax=30, skeleton_flat=40,
                hanged_man=60, spears=10, bare_table=10,
                gibs_1=10, gibs_2=10,
                junk_1=10, junk_2=10,junk_3=10
              },
  },
}

QUAKE1_THEMES =
{
  TECH =
  {
    building =
    {
      TECH_BASE=50,
    },

    ground =
    {
      TECH_GROUND=50,
    },

    hallway =
    {
      -- FIXME
    },

    exit =
    {
      -- FIXME
    },

    scenery =
    {
      -- FIXME
    },
  }, -- TECH
}


----------------------------------------------------------------

QUAKE1_MONSTERS =
{
  dog =
  {
    prob=10, guard_prob=1, trap_prob=1,
    health=25, damage=5, attack="melee",
  },

  fish =
  {
    health=25, damage=3, attack="melee",
  },

  grunt =
  {
    prob=80, guard_prob=11, trap_prob=11, cage_prob=11,
    health=30, damage=14, attack="hitscan",
    give={ {ammo="shell",count=5} },
  },

  enforcer =
  {
    prob=40, guard_prob=11, trap_prob=11, cage_prob=11,
    health=80, damage=18, attack="missile",
    give={ {ammo="cell",count=5} },
  },

  zombie =
  {
    prob=10, guard_prob=1, cage_prob=11,
    health=60, damage=8,  attack="melee",
  },

  scrag =
  {
    prob=60, guard_prob=11, trap_prob=11, cage_prob=11,
    health=80, damage=18, attack="missile",
  },

  spawn =
  {
    prob=10, trap_prob=11,
    health=80, damage=10, attack="melee",
  },

  knight =
  {
    prob=60, guard_prob=1, trap_prob=11, cage_prob=11,
    health=75, damage=9,  attack="melee",
  },

  hell_knt =
  {
    prob=30, guard_prob=31, trap_prob=21, cage_prob=11,
    health=250, damage=30, attack="missile",
  },

  ogre =
  {
    prob=40, guard_prob=21, trap_prob=31, cage_prob=11,
    health=200, damage=15, attack="missile",
    give={ {ammo="rocket",count=2} },
  },

  fiend =
  {
    prob=10, guard_prob=51, trap_prob=31,
    health=300, damage=20, attack="melee",
  },

  vore =
  {
    prob=10, guard_prob=31, trap_prob=31, cage_prob=11,
    health=400, damage=25, attack="missile",
  },

  shambler =
  {
    prob=10, guard_prob=31, trap_prob=21, cage_prob=11,
    health=600, damage=30, attack="hitscan",
    immunity={ rocket=0.5, grenade=0.5 },
  },
}


QUAKE1_WEAPONS =
{
  axe =
  {
    rate=2.0, damage=20, attack="melee",
  },

  pistol =
  {
    pref=10,
    rate=2.0, damage=20, attack="hitscan",
    ammo="shell", per=1,
  },

  ssg =
  {
    pref=50, add_prob=40,
    rate=1.4, damage=45, attack="hitscan", splash={0,3},
    ammo="shell", per=2,
    give={ {ammo="shell",count=5} },
  },

  grenade =
  {
    pref=10, add_prob=15,
    rate=1.5, damage= 5, attack="missile", splash={60,15,3},
    ammo="rocket", per=1,
    give={ {ammo="rocket",count=5} },
  },

  rocket =
  {
    pref=30, add_prob=10,
    rate=1.2, damage=80, attack="missile", splash={0,20,6,2},
    ammo="rocket", per=1,
    give={ {ammo="rocket",count=5} },
  },

  nailgun =
  {
    pref=50, add_prob=30,
    rate=5.0, damage=8, attack="missile",
    ammo="nail", per=1,
    give={ {ammo="nail",count=30} },
  },

  nailgun2 =
  {
    pref=80, add_prob=10,
    rate=5.0, damage=18, attack="missile",
    ammo="nail", per=2,
    give={ {ammo="nail",count=30} },
  },

  zapper =
  {
    pref=30, add_prob=2,
    rate=10, damage=30, attack="hitscan", splash={0,4},
    ammo="cell", per=1,
    give={ {ammo="cell",count=15} },
  },


  -- Notes:
  --
  -- Grenade damage (for a direct hit) is really zero, all of
  -- the actual damage comes from splash.
  --
  -- Rocket splash damage does not hurt the monster that was
  -- directly hit by the rocket.
  --
  -- Lightning bolt damage is done by three hitscan attacks
  -- over the same range (16 units apart).  As I read it, you
  -- can only hit two monsters if (a) the hitscan passes by
  -- the first one, or (b) the first one is killed.
}


QUAKE1_PICKUPS =
{
  -- HEALTH --

  heal_10 =
  {
    prob=20, cluster={ 1,2 },
    give={ {health=8} },   -- real amount is 5-10 units
  },

  heal_25 =
  {
    prob=50,
    give={ {health=25} },
  },

  mega =
  {
    prob=3, big_item=true,
    give={ {health=70} },  -- gives 100 but it rots aways
  },

  -- ARMOR --

  green_armor =
  {
    prob=9,
    give={ {health=30} },
  },

  yellow_armor =
  {
    prob=3,
    give={ {health=90} },
  },

  red_armor =
  {
    prob=1,
    give={ {health=160} },
  },

  -- AMMO --

  shell_20 =
  {
    give={ {ammo="shell",count=20} },
  },

  shell_40 =
  {
    give={ {ammo="shell",count=40} },
  },

  nail_25 =
  {
    give={ {ammo="nail",count=25} },
  },

  nail_50 =
  {
    give={ {ammo="nail",count=50} },
  },

  rocket_5 =
  {
    give={ {ammo="rocket",count=5} },
  },

  rocket_10 =
  {
    give={ {ammo="rocket",count=10} },
  },

  cell_6 =
  {
    give={ {ammo="cell",count=6} },
  },

  cell_12 =
  {
    give={ {ammo="cell",count=12} },
  },
}


QUAKE1_PLAYER_MODEL =
{
  quakeguy =
  {
    stats   = { health=0, shell=0, nail=0, rocket=0, cell=0 },
    weapons = { pistol=1, axe=1 },
  }
}


------------------------------------------------------------

QUAKE1_EPISODE_THEMES =
{
  { BASE=7, },
  { BASE=6, },
  { BASE=6, },
  { BASE=6, },
}

QUAKE1_KEY_NUM_PROBS =
{
  small   = { 90, 50, 20 },
  regular = { 40, 90, 40 },
  large   = { 20, 50, 90 },
}



----------------------------------------------------------------

function Quake1_get_levels()
  local list = {}

  local EP_NUM  = sel(OB_CONFIG.length == "full", 4, 1)
  local MAP_NUM = sel(OB_CONFIG.length == "single", 1, 7)

  if OB_CONFIG.length == "few" then MAP_NUM = 3 end

  for episode = 1,EP_NUM do
    for map = 1,MAP_NUM do

      local LEV =
      {
        name = string.format("e%dm%d", episode, map),

        ep_along = map / MAP_NUM,

        theme_ref = "BASE",
      }

      table.insert(list, LEV)
    end -- for map

  end -- for episode

  return list
end

function Quake1_describe_levels()

  -- FIXME handle themes properly !!!

  local desc_list = Naming_generate("GOTHIC", #GAME.all_levels, PARAM.max_level_desc)

  for index,LEV in ipairs(GAME.all_levels) do
    LEV.description = desc_list[index]
  end
end

function Quake1_setup()

  GAME.player_model = QUAKE1_PLAYER_MODEL

  GAME.dm = {}

  Game_merge_tab("things",   QUAKE1_THINGS)
  Game_merge_tab("monsters", QUAKE1_MONSTERS)
  Game_merge_tab("weapons",  QUAKE1_WEAPONS)
  Game_merge_tab("pickups",  QUAKE1_PICKUPS)

  Game_merge_tab("quests",  QUAKE1_QUESTS)

  Game_merge_tab("combos", QUAKE1_COMBOS)
  Game_merge_tab("exits",  QUAKE1_EXITS)
--  hallways  nil,

--  Game_merge_tab("doors", QUAKE1_DOORS)
  Game_merge_tab("key_doors", QUAKE1_KEY_DOORS)

  Game_merge_tab("rooms",  QUAKE1_ROOMS)
  Game_merge_tab("themes", QUAKE1_THEMES)

  Game_merge_tab("misc_fabs", QUAKE1_MISC_PREFABS)

  GAME.room_heights = { [128]=50 }
  GAME.space_range  = { 50, 90 }
  GAME.door_probs = { combo_diff=90, normal=20, out_diff=1 }
  GAME.window_probs = { out_diff=0, combo_diff=0, normal=0 }
end


UNFINISHED["quake1"] =
{
  label = "Quake 1",

  format = "quake1",

  setup_func = Quake1_setup,

  param =
  {
    -- TODO

    -- need to put center of map around (0,0) since the quake
    -- engine needs all coords to lie between -4000 and +4000.
    center_map = true,

    seed_size = 240,

    sky_tex  = "sky4",
    sky_flat = "sky4",

    -- the name buffer in Quake can fit 39 characters, however
    -- the on-screen space for the name is much less.
    max_level_desc = 20,

    palette_mons = 4,

  },

  hooks =
  {
    get_levels = Quake1_get_levels,
    describe_levels = Quake1_describe_levels,
  },
}


OB_THEMES["q1_base"] =
{
  ref = "TECH",
  label = "Base",

  for_games = { quake1=1 },
}

