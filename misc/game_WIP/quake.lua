----------------------------------------------------------------
-- GAME DEF : Quake
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2012 Andrew Apted
--  Copyright (C)      2011 Chris Pisarczyk
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

QUAKE = {}

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


QUAKE.PARAMETERS =
{
  -- Quake engine needs all coords to lie between -4000 and +4000.
  -- (limitation of the client/server protocol).
  map_limit = 8000

  centre_map = true

  use_spawnflags = true
  entity_delta_z = 24

  -- keys are lost when you open a locked door
  lose_keys = true

  bridges = true
  extra_floors = true
  deep_liquids = true

  jump_height = 42

  -- the name buffer in Quake can fit 39 characters, however
  -- the on-screen space for the name is much less.
  max_name_length = 20

  skip_monsters = { 20,30 }

  time_factor   = 1.0
  damage_factor = 1.0
  ammo_factor   = 1.2
  health_factor = 1.0
  monster_factor = 0.6
}


----------------------------------------------------------------

QUAKE.MATERIALS =
{
  -- special materials --
  _ERROR = { t="metal1_1" }  -- METAL1_1
  _SKY   = { t="sky4" }

  ADOOR01_2  = { t="adoor01_2" }
  ADOOR02_2  = { t="adoor02_2" }
  ADOOR03_2  = { t="adoor03_2" }
  ADOOR03_3  = { t="adoor03_3" }
  ADOOR03_4  = { t="adoor03_4" }
  ADOOR03_5  = { t="adoor03_5" }
  ADOOR03_6  = { t="adoor03_6" }
  ADOOR09_1  = { t="adoor09_1" }
  ADOOR09_2  = { t="adoor09_2" }
  AFLOOR1_3  = { t="afloor1_3" }
  AFLOOR1_4  = { t="afloor1_4" }
  AFLOOR1_8  = { t="afloor1_8" }
  AFLOOR3_1  = { t="afloor3_1" }
  ALTAR1_1   = { t="altar1_1" }
  ALTAR1_3   = { t="altar1_3" }
  ALTAR1_4   = { t="altar1_4" }
  ALTAR1_6   = { t="altar1_6" }
  ALTAR1_7   = { t="altar1_7" }
  ALTAR1_8   = { t="altar1_8" }
  ALTARB_1   = { t="altarb_1" }
  ALTARB_2   = { t="altarb_2" }
  ALTARC_1   = { t="altarc_1" }
  ARCH7      = { t="arch7" }
  ARROW_M    = { t="arrow_m" }
  AZ1_6      = { t="az1_6" }
  AZFLOOR1_1 = { t="azfloor1_1" }
  AZSWITCH3  = { t="azswitch3" }
  AZWALL1_5  = { t="azwall1_5" }
  AZWALL3_1  = { t="azwall3_1" }
  AZWALL3_2  = { t="azwall3_2" }
  BASEBUTN3  = { t="basebutn3" }
  BLACK      = { t="black" }
  BODIESA2_1 = { t="bodiesa2_1" }
  BODIESA2_4 = { t="bodiesa2_4" }
  BODIESA3_1 = { t="bodiesa3_1" }
  BODIESA3_2 = { t="bodiesa3_2" }
  BODIESA3_3 = { t="bodiesa3_3" }
  BRICKA2_1  = { t="bricka2_1" }
  BRICKA2_2  = { t="bricka2_2" }
  BRICKA2_4  = { t="bricka2_4" }
  BRICKA2_6  = { t="bricka2_6" }
  CARCH02    = { t="carch02" }
  CARCH03    = { t="carch03" }
  CARCH04_1  = { t="carch04_1" }
  CARCH04_2  = { t="carch04_2" }
  CEIL1_1    = { t="ceil1_1" }
  CEILING1_3 = { t="ceiling1_3" }
  CEILING4   = { t="ceiling4" }
  CEILING5   = { t="ceiling5" }
  CHURCH1_2  = { t="church1_2" }
  CHURCH7    = { t="church7" }

  CITY1_4    = { t="city1_4" }
  CITY1_7    = { t="city1_7" }
  CITY2_1    = { t="city2_1" }
  CITY2_2    = { t="city2_2" }
  CITY2_3    = { t="city2_3" }
  CITY2_5    = { t="city2_5" }
  CITY2_6    = { t="city2_6" }
  CITY2_7    = { t="city2_7" }
  CITY2_8    = { t="city2_8" }
  CITY3_2    = { t="city3_2" }
  CITY3_4    = { t="city3_4" }
  CITY4_1    = { t="city4_1" }
  CITY4_2    = { t="city4_2" }
  CITY4_5    = { t="city4_5" }
  CITY4_6    = { t="city4_6" }
  CITY4_7    = { t="city4_7" }
  CITY4_8    = { t="city4_8" }
  CITY5_1    = { t="city5_1" }
  CITY5_2    = { t="city5_2" }
  CITY5_3    = { t="city5_3" }
  CITY5_4    = { t="city5_4" }
  CITY5_6    = { t="city5_6" }
  CITY5_7    = { t="city5_7" }
  CITY5_8    = { t="city5_8" }
  CITY6_3    = { t="city6_3" }
  CITY6_4    = { t="city6_4" }
  CITY6_7    = { t="city6_7" }
  CITY6_8    = { t="city6_8" }
  CITY8_2    = { t="city8_2" }
  CITYA1_1   = { t="citya1_1" }
  CLIP       = { t="clip" }
  COLUMN01_3 = { t="column01_3" }
  COLUMN01_4 = { t="column01_4" }
  COLUMN1_2  = { t="column1_2" }
  COLUMN1_4  = { t="column1_4" }
  COLUMN1_5  = { t="column1_5" }
  COMP1_1    = { t="comp1_1" }
  COMP1_2    = { t="comp1_2" }
  COMP1_3    = { t="comp1_3" }
  COMP1_4    = { t="comp1_4" }
  COMP1_5    = { t="comp1_5" }
  COMP1_6    = { t="comp1_6" }
  COMP1_7    = { t="comp1_7" }
  COMP1_8    = { t="comp1_8" }
  COP1_1     = { t="cop1_1" }
  COP1_2     = { t="cop1_2" }
  COP1_3     = { t="cop1_3" }
  COP1_4     = { t="cop1_4" }
  COP1_5     = { t="cop1_5" }
  COP1_6     = { t="cop1_6" }
  COP1_7     = { t="cop1_7" }
  COP1_8     = { t="cop1_8" }
  COP2_1     = { t="cop2_1" }
  COP2_2     = { t="cop2_2" }
  COP2_3     = { t="cop2_3" }
  COP2_4     = { t="cop2_4" }
  COP2_5     = { t="cop2_5" }
  COP2_6     = { t="cop2_6" }
  COP3_1     = { t="cop3_1" }
  COP3_2     = { t="cop3_2" }
  COP3_4     = { t="cop3_4" }
  COP4_3     = { t="cop4_3" }
  COP4_5     = { t="cop4_5" }

  CRATE0_SIDE = { t="crate0_side" }
  CRATE0_TOP  = { t="crate0_top" }
  CRATE1_SIDE = { t="crate1_side" }
  CRATE1_TOP  = { t="crate1_top" }

  DEM4_1     = { t="dem4_1" }
  DEM4_4     = { t="dem4_4" }
  DEM5_3     = { t="dem5_3" }
  DEMC4_4    = { t="demc4_4" }
  DOOR01_2   = { t="door01_2" }
  DOOR02_1   = { t="door02_1" }
  DOOR02_2   = { t="door02_2" }
  DOOR02_3   = { t="door02_3" }
  DOOR02_7   = { t="door02_7" }
  DOOR03_2   = { t="door03_2" }
  DOOR03_3   = { t="door03_3" }
  DOOR03_4   = { t="door03_4" }
  DOOR03_5   = { t="door03_5" }
  DOOR04_1   = { t="door04_1" }
  DOOR04_2   = { t="door04_2" }
  DOOR05_2   = { t="door05_2" }
  DOOR05_3   = { t="door05_3" }
  DOPEBACK   = { t="dopeback" }
  DOPEFISH   = { t="dopefish" }
  DR01_1     = { t="dr01_1" }
  DR01_2     = { t="dr01_2" }
  DR02_1     = { t="dr02_1" }
  DR02_2     = { t="dr02_2" }
  DR03_1     = { t="dr03_1" }
  DR05_2     = { t="dr05_2" }
  DR07_1     = { t="dr07_1" }
  DUNG01_1   = { t="dung01_1" }
  DUNG01_2   = { t="dung01_2" }
  DUNG01_3   = { t="dung01_3" }
  DUNG01_4   = { t="dung01_4" }
  DUNG01_5   = { t="dung01_5" }
  DUNG02_1   = { t="dung02_1" }
  DUNG02_5   = { t="dung02_5" }
  ECOP1_1    = { t="ecop1_1" }
  ECOP1_4    = { t="ecop1_4" }
  ECOP1_6    = { t="ecop1_6" }
  ECOP1_7    = { t="ecop1_7" }
  ECOP1_8    = { t="ecop1_8" }
  EDOOR01_1  = { t="edoor01_1" }
  ELWALL1_1  = { t="elwall1_1" }
  ELWALL2_4  = { t="elwall2_4" }
  EMETAL1_3  = { t="emetal1_3" }
  ENTER01    = { t="enter01" }
  EXIT01     = { t="exit01" }
  EXIT02_2   = { t="exit02_2" }
  EXIT02_3   = { t="exit02_3" }
  FLOOR01_5  = { t="floor01_5" }

  GRAVE01_1  = { t="grave01_1" }
  GRAVE01_3  = { t="grave01_3" }
  GRAVE02_1  = { t="grave02_1" }
  GRAVE02_2  = { t="grave02_2" }
  GRAVE02_3  = { t="grave02_3" }
  GRAVE02_4  = { t="grave02_4" }
  GRAVE02_5  = { t="grave02_5" }
  GRAVE02_6  = { t="grave02_6" }
  GRAVE02_7  = { t="grave02_7" }
  GRAVE03_1  = { t="grave03_1" }
  GRAVE03_2  = { t="grave03_2" }
  GRAVE03_3  = { t="grave03_3" }
  GRAVE03_4  = { t="grave03_4" }
  GRAVE03_5  = { t="grave03_5" }
  GRAVE03_6  = { t="grave03_6" }
  GRAVE03_7  = { t="grave03_7" }
  GROUND1_1  = { t="ground1_1" }
  GROUND1_2  = { t="ground1_2" }
  GROUND1_5  = { t="ground1_5" }
  GROUND1_6  = { t="ground1_6" }
  GROUND1_7  = { t="ground1_7" }
  GROUND1_8  = { t="ground1_8" }
  KEY01_1    = { t="key01_1" }
  KEY01_2    = { t="key01_2" }
  KEY01_3    = { t="key01_3" }
  KEY02_1    = { t="key02_1" }
  KEY02_2    = { t="key02_2" }
  KEY03_1    = { t="key03_1" }
  KEY03_2    = { t="key03_2" }
  KEY03_3    = { t="key03_3" }
  LGMETAL    = { t="lgmetal" }
  LGMETAL2   = { t="lgmetal2" }
  LGMETAL3   = { t="lgmetal3" }
  LGMETAL4   = { t="lgmetal4" }
  LIGHT1_1   = { t="light1_1" }
  LIGHT1_2   = { t="light1_2" }
  LIGHT1_3   = { t="light1_3" }
  LIGHT1_4   = { t="light1_4" }
  LIGHT1_5   = { t="light1_5" }
  LIGHT1_7   = { t="light1_7" }
  LIGHT1_8   = { t="light1_8" }
  LIGHT3_3   = { t="light3_3" }
  LIGHT3_5   = { t="light3_5" }
  LIGHT3_6   = { t="light3_6" }
  LIGHT3_7   = { t="light3_7" }
  LIGHT3_8   = { t="light3_8" }

  M5_3       = { t="m5_3" }
  M5_5       = { t="m5_5" }
  M5_8       = { t="m5_8" }
  MET5_1     = { t="met5_1" }
  MET5_2     = { t="met5_2" }
  MET5_3     = { t="met5_3" }
  METAL1_1   = { t="metal1_1" }
  METAL1_2   = { t="metal1_2" }
  METAL1_3   = { t="metal1_3" }
  METAL1_4   = { t="metal1_4" }
  METAL1_5   = { t="metal1_5" }
  METAL1_6   = { t="metal1_6" }
  METAL1_7   = { t="metal1_7" }
  METAL2_1   = { t="metal2_1" }
  METAL2_2   = { t="metal2_2" }
  METAL2_3   = { t="metal2_3" }
  METAL2_4   = { t="metal2_4" }
  METAL2_5   = { t="metal2_5" }
  METAL2_6   = { t="metal2_6" }
  METAL2_7   = { t="metal2_7" }
  METAL2_8   = { t="metal2_8" }
  METAL3_2   = { t="metal3_2" }
  METAL4_2   = { t="metal4_2" }
  METAL4_3   = { t="metal4_3" }
  METAL4_4   = { t="metal4_4" }
  METAL4_5   = { t="metal4_5" }
  METAL4_6   = { t="metal4_6" }
  METAL4_7   = { t="metal4_7" }
  METAL4_8   = { t="metal4_8" }
  METAL5_1   = { t="metal5_1" }
  METAL5_2   = { t="metal5_2" }
  METAL5_3   = { t="metal5_3" }
  METAL5_4   = { t="metal5_4" }
  METAL5_5   = { t="metal5_5" }
  METAL5_6   = { t="metal5_6" }
  METAL5_8   = { t="metal5_8" }
  METAL6_1   = { t="metal6_1" }
  METAL6_2   = { t="metal6_2" }
  METAL6_3   = { t="metal6_3" }
  METAL6_4   = { t="metal6_4" }
  METALT1_1  = { t="metalt1_1" }
  METALT1_2  = { t="metalt1_2" }
  METALT1_7  = { t="metalt1_7" }
  METALT2_1  = { t="metalt2_1" }
  METALT2_2  = { t="metalt2_2" }
  METALT2_3  = { t="metalt2_3" }
  METALT2_4  = { t="metalt2_4" }
  METALT2_5  = { t="metalt2_5" }
  METALT2_6  = { t="metalt2_6" }
  METALT2_7  = { t="metalt2_7" }
  METALT2_8  = { t="metalt2_8" }
  METFLOR2_1 = { t="metflor2_1" }
  MMETAL1_1  = { t="mmetal1_1" }
  MMETAL1_2  = { t="mmetal1_2" }
  MMETAL1_3  = { t="mmetal1_3" }
  MMETAL1_5  = { t="mmetal1_5" }
  MMETAL1_6  = { t="mmetal1_6" }
  MMETAL1_7  = { t="mmetal1_7" }
  MMETAL1_8  = { t="mmetal1_8" }
  MSWTCH_2   = { t="mswtch_2" }
  MSWTCH_3   = { t="mswtch_3" }
  MSWTCH_4   = { t="mswtch_4" }
  MUH_BAD    = { t="muh_bad" }
  NMETAL2_1  = { t="nmetal2_1" }
  NMETAL2_6  = { t="nmetal2_6" }
  PLAT_SIDE1 = { t="plat_side1" }
  PLAT_STEM  = { t="plat_stem" }
  PLAT_TOP1  = { t="plat_top1" }
  PLAT_TOP2  = { t="plat_top2" }

  QUAKE      = { t="quake" }
  RAVEN      = { t="raven" }
  ROCK1_2    = { t="rock1_2" }
  ROCK3_2    = { t="rock3_2" }
  ROCK3_7    = { t="rock3_7" }
  ROCK3_8    = { t="rock3_8" }
  ROCK4_1    = { t="rock4_1" }
  ROCK4_2    = { t="rock4_2" }
  ROCK5_2    = { t="rock5_2" }
  RUNE1_1    = { t="rune1_1" }
  RUNE1_4    = { t="rune1_4" }
  RUNE1_5    = { t="rune1_5" }
  RUNE1_6    = { t="rune1_6" }
  RUNE1_7    = { t="rune1_7" }
  RUNE2_1    = { t="rune2_1" }
  RUNE2_2    = { t="rune2_2" }
  RUNE2_3    = { t="rune2_3" }
  RUNE2_4    = { t="rune2_4" }
  RUNE2_5    = { t="rune2_5" }
  RUNE_A     = { t="rune_a" }
  SFLOOR1_2  = { t="sfloor1_2" }
  SFLOOR3_2  = { t="sfloor3_2" }
  SFLOOR4_1  = { t="sfloor4_1" }
  SFLOOR4_2  = { t="sfloor4_2" }
  SFLOOR4_4  = { t="sfloor4_4" }
  SFLOOR4_5  = { t="sfloor4_5" }
  SFLOOR4_6  = { t="sfloor4_6" }
  SFLOOR4_7  = { t="sfloor4_7" }
  SFLOOR4_8  = { t="sfloor4_8" }
  SKILL0     = { t="skill0" }
  SKILL1     = { t="skill1" }
  SKILL2     = { t="skill2" }
  SKILL3     = { t="skill3" }
  SLIP1      = { t="slip1" }
  SLIP2      = { t="slip2" }
  SLIPBOTSD  = { t="slipbotsd" }
  SLIPLITE   = { t="sliplite" }
  SLIPSIDE   = { t="slipside" }
  SLIPTOPSD  = { t="sliptopsd" }
  STONE1_3   = { t="stone1_3" }
  STONE1_5   = { t="stone1_5" }
  STONE1_7   = { t="stone1_7" }
  SWITCH_1   = { t="switch_1" }
  SWTCH1_1   = { t="swtch1_1" }

  TECH01_1   = { t="tech01_1" }
  TECH01_2   = { t="tech01_2" }
  TECH01_3   = { t="tech01_3" }
  TECH01_5   = { t="tech01_5" }
  TECH01_6   = { t="tech01_6" }
  TECH01_7   = { t="tech01_7" }
  TECH01_9   = { t="tech01_9" }
  TECH02_1   = { t="tech02_1" }
  TECH02_2   = { t="tech02_2" }
  TECH02_3   = { t="tech02_3" }
  TECH02_5   = { t="tech02_5" }
  TECH02_6   = { t="tech02_6" }
  TECH02_7   = { t="tech02_7" }
  TECH03_1   = { t="tech03_1" }
  TECH03_2   = { t="tech03_2" }
  TECH04_1   = { t="tech04_1" }
  TECH04_2   = { t="tech04_2" }
  TECH04_3   = { t="tech04_3" }
  TECH04_4   = { t="tech04_4" }
  TECH04_5   = { t="tech04_5" }
  TECH04_6   = { t="tech04_6" }
  TECH04_7   = { t="tech04_7" }
  TECH04_8   = { t="tech04_8" }
  TECH05_1   = { t="tech05_1" }
  TECH05_2   = { t="tech05_2" }
  TECH06_1   = { t="tech06_1" }
  TECH06_2   = { t="tech06_2" }
  TECH07_1   = { t="tech07_1" }
  TECH07_2   = { t="tech07_2" }
  TECH08_1   = { t="tech08_1" }
  TECH08_2   = { t="tech08_2" }
  TECH09_3   = { t="tech09_3" }
  TECH09_4   = { t="tech09_4" }
  TECH10_1   = { t="tech10_1" }
  TECH10_3   = { t="tech10_3" }
  TECH11_1   = { t="tech11_1" }
  TECH11_2   = { t="tech11_2" }
  TECH12_1   = { t="tech12_1" }
  TECH13_2   = { t="tech13_2" }
  TECH14_1   = { t="tech14_1" }
  TECH14_2   = { t="tech14_2" }
  TELE_TOP   = { t="tele_top" }
  TLIGHT01   = { t="tlight01" }
  TLIGHT01_2 = { t="tlight01_2" }
  TLIGHT02   = { t="tlight02" }
  TLIGHT03   = { t="tlight03" }
  TLIGHT05   = { t="tlight05" }
  TLIGHT07   = { t="tlight07" }
  TLIGHT08   = { t="tlight08" }
  TLIGHT09   = { t="tlight09" }
  TLIGHT10   = { t="tlight10" }
  TLIGHT11   = { t="tlight11" }
  TWALL1_1   = { t="twall1_1" }
  TWALL1_2   = { t="twall1_2" }
  TWALL1_4   = { t="twall1_4" }
  TWALL2_1   = { t="twall2_1" }
  TWALL2_2   = { t="twall2_2" }
  TWALL2_3   = { t="twall2_3" }
  TWALL2_5   = { t="twall2_5" }
  TWALL2_6   = { t="twall2_6" }
  TWALL3_1   = { t="twall3_1" }
  TWALL5_1   = { t="twall5_1" }
  TWALL5_2   = { t="twall5_2" }
  TWALL5_3   = { t="twall5_3" }

  UNWALL1_8  = { t="unwall1_8" }
  UWALL1_2   = { t="uwall1_2" }
  UWALL1_3   = { t="uwall1_3" }
  UWALL1_4   = { t="uwall1_4" }
  VINE1_2    = { t="vine1_2" }
  WALL11_2   = { t="wall11_2" }
  WALL11_6   = { t="wall11_6" }
  WALL14_5   = { t="wall14_5" }
  WALL14_6   = { t="wall14_6" }
  WALL16_7   = { t="wall16_7" }
  WALL3_4    = { t="wall3_4" }
  WALL5_4    = { t="wall5_4" }
  WALL9_3    = { t="wall9_3" }
  WALL9_8    = { t="wall9_8" }
  WARCH05    = { t="warch05" }
  WBRICK1_4  = { t="wbrick1_4" }
  WBRICK1_5  = { t="wbrick1_5" }
  WCEILING4  = { t="wceiling4" }
  WCEILING5  = { t="wceiling5" }
  WENTER01   = { t="wenter01" }
  WEXIT01    = { t="wexit01" }
  WGRASS1_1  = { t="wgrass1_1" }
  WGRND1_5   = { t="wgrnd1_5" }
  WGRND1_6   = { t="wgrnd1_6" }
  WGRND1_8   = { t="wgrnd1_8" }
  WINDOW01_1 = { t="window01_1" }
  WINDOW01_2 = { t="window01_2" }
  WINDOW01_3 = { t="window01_3" }
  WINDOW01_4 = { t="window01_4" }
  WINDOW02_1 = { t="window02_1" }
  WINDOW03   = { t="window03" }
  WINDOW1_2  = { t="window1_2" }
  WINDOW1_3  = { t="window1_3" }
  WINDOW1_4  = { t="window1_4" }
  WIZ1_1     = { t="wiz1_1" }
  WIZ1_4     = { t="wiz1_4" }
  WIZMET1_1  = { t="wizmet1_1" }
  WIZMET1_2  = { t="wizmet1_2" }
  WIZMET1_3  = { t="wizmet1_3" }
  WIZMET1_4  = { t="wizmet1_4" }
  WIZMET1_5  = { t="wizmet1_5" }
  WIZMET1_6  = { t="wizmet1_6" }
  WIZMET1_7  = { t="wizmet1_7" }
  WIZMET1_8  = { t="wizmet1_8" }
  WIZWIN1_2  = { t="wizwin1_2" }
  WIZWIN1_8  = { t="wizwin1_8" }
  WIZWOOD1_2 = { t="wizwood1_2" }
  WIZWOOD1_3 = { t="wizwood1_3" }
  WIZWOOD1_4 = { t="wizwood1_4" }
  WIZWOOD1_5 = { t="wizwood1_5" }
  WIZWOOD1_6 = { t="wizwood1_6" }
  WIZWOOD1_7 = { t="wizwood1_7" }
  WIZWOOD1_8 = { t="wizwood1_8" }
  WKEY02_1   = { t="wkey02_1" }
  WKEY02_2   = { t="wkey02_2" }
  WKEY02_3   = { t="wkey02_3" }
  WMET1_1    = { t="wmet1_1" }
  WMET2_1    = { t="wmet2_1" }
  WMET2_2    = { t="wmet2_2" }
  WMET2_3    = { t="wmet2_3" }
  WMET2_4    = { t="wmet2_4" }
  WMET2_6    = { t="wmet2_6" }
  WMET3_1    = { t="wmet3_1" }
  WMET3_3    = { t="wmet3_3" }
  WMET3_4    = { t="wmet3_4" }
  WMET4_2    = { t="wmet4_2" }
  WMET4_3    = { t="wmet4_3" }
  WMET4_4    = { t="wmet4_4" }
  WMET4_5    = { t="wmet4_5" }
  WMET4_6    = { t="wmet4_6" }
  WMET4_7    = { t="wmet4_7" }
  WMET4_8    = { t="wmet4_8" }
  WOOD1_1    = { t="wood1_1" }
  WOOD1_5    = { t="wood1_5" }
  WOOD1_7    = { t="wood1_7" }
  WOOD1_8    = { t="wood1_8" }
  WOODFLR1_2 = { t="woodflr1_2" }
  WOODFLR1_4 = { t="woodflr1_4" }
  WOODFLR1_5 = { t="woodflr1_5" }
  WSWAMP1_2  = { t="wswamp1_2" }
  WSWAMP1_4  = { t="wswamp1_4" }
  WSWAMP2_1  = { t="wswamp2_1" }
  WSWAMP2_2  = { t="wswamp2_2" }
  WSWITCH1   = { t="wswitch1" }
  WWALL1_1   = { t="wwall1_1" }
  WWOOD1_5   = { t="wwood1_5" }
  WWOOD1_7   = { t="wwood1_7" }
  Z_EXIT     = { t="z_exit" }

  -- special stuff
  TRIGGER    = { t="trigger" }

  TELEPORT   = { t="*teleport" }

  L_LAVA1    = { t="*lava1"  }
  L_SLIME    = { t="*slime"  }
  L_SLIME0   = { t="*slime0" }
  L_SLIME1   = { t="*slime1" }
  L_WATER0   = { t="*water0" }
  L_WATER1   = { t="*water1" }
  L_WATER2   = { t="*water2" }

  -- Oblige specific textures
  O_CARVE    = { t="o_carve" }
  O_BOLT     = { t="o_bolt"  }


  BUTTON = { t="+0button" }

  BUTNN  = { t="+0butnn" }

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

---  *04awater1
---  *04mwat1
---  *04mwat2
---  *04water1
---  *04water2
}


QUAKE.LIQUIDS =
{
  water  = { mat="L_WATER0", medium="water", light=0, special=0 }
  slime0 = { mat="L_SLIME0", medium="slime", light=0, special=0, damage=99 }
  slime  = { mat="L_SLIME",  medium="slime", light=0, special=0, damage=99 }
  lava1  = { mat="L_LAVA1",  medium="lava",  light=1, special=0, damage=99, fireballs=1 }
}


----------------------------------------------------------------


QUAKE.SKIN_DEFAULTS =
{
}


QUAKE.SKINS =
{
  ----| STARTS |----

  Start_basic =
  {
    _prefab = "START_SPOT"
    _where  = "middle"

    top = "O_BOLT"
  }

  START_LEDGE =
  {
    _prefab = "START_LEDGE"
    _where  = "edge"
    _long   = 192
    _deep   = 64
  }


  ----| EXITS |----

  Exit_basic =
  {
    _prefab = "QUAKE_EXIT_PAD"
    _where  = "middle"

    pad  = "TELE_TOP"
    side = "METAL1_1"
  }


  ----| STAIRS |----

  Stair_Up1 =
  {
    _prefab = "STAIR_6"
    _where  = "chunk"
    _deltas = { 32,48,48,64,64,80 }
  }

  Stair_Down1 =
  {
    _prefab = "NICHE_STAIR_8"
    _where  = "chunk"
    _deltas = { -32,-48,-64,-64,-80,-96 }
  }

  Lift_Up1 =
  {
    _prefab = "QUAKE_LIFT_UP"
    _where  = "chunk"
    _deltas = { 96,128,128,160,192 }

    lift = "METAL2_6"
  }

  Lift_Down1 =
  {
    _prefab = "QUAKE_LIFT_DOWN"
    _where  = "chunk"
    _deltas = { -96,-128,-128,-160,-192 }

    lift = "MET5_1"
  }


  ----| ARCHES |----

  Arch1 =
  {
    _prefab = "ARCH"
    _where  = "edge"
    _long   = 192
    _deep   = 64
  }

  MiniHall_Arch1 =
  {
    _prefab = "FAT_ARCH1"
    _shape  = "I"
    _delta  = 0
  }


  ----| DOORS |----

  Door_plain =
  {
    _prefab = "QUAKE_DOOR"
    _where  = "edge"
    _long   = 192
    _deep   = 32

    door = "ADOOR02_2"
  }


  ----| ITEM / KEY |----

  Item_niche =
  {
    _prefab = "ITEM_NICHE"
    _where  = "edge"
    _long   = 192
    _deep   = 64

    light = 128
    style = 11
  }

  Pedestal_tech =
  {
    _prefab = "PEDESTAL"
    _where  = "middle"

    top  = "LIGHT1_7"
    side = "METAL1_2"

    light = 160
    style = 11
  }

  Pedestal_gothic =
  {
    _prefab = "PEDESTAL"
    _where  = "middle"

    top  = "WINDOW1_4"  -- METAL6_4
    side = "TECH02_5"   -- METAL5_8

    light = 160
    style = 11
  }


  ----| PICTURES |----

  Pic_Carve =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "O_CARVE"
    pic_w = 64
    pic_h = 64

    light = 64
  }

  Pic_Bolt =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "O_BOLT"
    pic_w = 64
    pic_h = 64

    light = 64
  }


  -- tech --

  Pic_Computer1 =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "COMP1_6"
    pic_w = 128
    pic_h = 64

    light = 64
  }

  Pic_Computer2 =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = { TWALL2_1=50, TWALL2_2=10 }
    pic_w = 64
    pic_h = 128

    light = 64
  }

  Pic_Light07 =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "TLIGHT07"
    pic_w = 64
    pic_h = 128

    light = 128  -- TODO: larger (e.g. 192 or 256)

    effect = { [0]=50, [10]=15, [4]=5 }
  }

  Pic_Light03 =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "TLIGHT03"
    pic_w = 32
    pic_h = 64

    light = 128
  }


  -- gothic --

  Pic_StainGlass =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = { WINDOW01_1=50, WINDOW01_2=50, WINDOW01_3=50 }
    pic_w = 64
    pic_h = 128  -- !! FIXME should be 192

    light = 96
  }

  Pic_StainGlass2 =
  {
    _copy = "Pic_StainGlass"

    pic = { WINDOW02_1=50, WINDOW01_4=50 }
  }

  Pic_Window3 =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "WINDOW1_3"
    pic_w = 64
    pic_h = 64

    light = 96
  }

  Pic_WoodCarve =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "WOOD1_8"
    pic_w = 64
    pic_h = 64

    light = 32
  }

  Pic_YellowLight3 =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "LIGHT1_3"
    pic_w = 64
    pic_h = 64

    light = 128
  }

  Pic_CrossLight =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "LIGHT3_6"
    pic_w = 32
    pic_h = 64

    light = 128
  }


  Pic_Demon =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "DEM4_4"
    pic_w = 64
    pic_h = 128

    light = 48
  }

  Pic_DemonLit =
  {
    _copy = "Pic_Demon"

    pic = "DEM5_3"

    light = 128
  }

  Pic_BloodyHead =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "METALT1_7"
    pic_w = 64
    pic_h = 64

    light = 32
  }


  --- LOCKED DOORS ---

  Locked_silver =
  {
    _prefab = "QUAKE_DOOR"
    _where  = "edge"
    _key    = "k_silver"
    _long = 192
    _deep = 48

    door = "DOOR01_2"
    door_flags = 16  -- 16 = DOOR_SILVER_KEY
  }

  Locked_gold =
  {
    _prefab = "QUAKE_DOOR"
    _where  = "edge"
    _key    = "k_gold"
    _long = 192
    _deep = 48

    door = "DOOR01_2"
    door_flags = 8   -- 8 = DOOR_GOLD_KEY
  }


  Locked_silver_wide =
  {
    _prefab = "QUAKE_DOOR_W_KEY_PIC"
    _where  = "edge"
    _key    = "k_silver"
    _long = 320
    _deep = 48

    door_sub = "Locked_silver"
    key_sub  = "Pic_SilverKey"
  }

  Locked_gold_wide =
  {
    _prefab = "QUAKE_DOOR_W_KEY_PIC"
    _where  = "edge"
    _key    = "k_gold"
    _long = 320
    _deep = 48

    door_sub = "Locked_gold"
    key_sub  = "Pic_GoldKey"
  }


  Pic_SilverKey =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    
    pic = "KEY03_1"
    pic_w = 32
    pic_h = 32

    light = 64
    effect = 5
  }

  Pic_GoldKey =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    
    pic = "KEY03_2"
    pic_w = 32
    pic_h = 32

    light = 64
    effect = 5
  }


  ----| SWITCHED DOORS |---- 

  Door_SW_1 =
  {
    _prefab = "QUAKE_DOOR"
    _where  = "edge"
    _switch = "sw_foo"
    _long = 192
    _deep = 32

    door = "ADOOR09_1"
    message = "Find the button dude!"
    wait = -1
  }

  Door_SW_wide =
  {
    _prefab = "QUAKE_DOOR_W_KEY_PIC"
    _where  = "edge"
    _switch = "sw_foo"
    _long = 320
    _deep = 32

    door_sub = "Door_SW_1"
     key_sub = "Pic_Gears"
  }

  Pic_Gears =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    
    pic = "KEY03_3"
    pic_w = 64
    pic_h = 64

    light = 64
  }


  Switch_1_Edge =
  {
    _prefab = "QUAKE_WALL_SWITCH"
    _where  = "edge"
    _long   = 192
    _deep   = 48

  }

  Switch_floor1 =
  {
    _prefab = "QUAKE_FLOOR_SWITCH"
    _where  = "middle"
    _switch = "sw_foo"

    switch = "BUTNN"
    side   = "MET5_1"
  }


  ---| HALLWAY PIECES |---

  Hall_Basic_I =
  {
    _prefab = "HALL_BASIC_I"
    _shape  = "I"
  }

  Hall_Basic_C =
  {
    _prefab = "HALL_BASIC_C"
    _shape  = "C"

    torch_ent = "torch"
  }

  Hall_Basic_T =
  {
    _prefab = "HALL_BASIC_T"
    _shape  = "T"
  }

  Hall_Basic_P =
  {
    _prefab = "HALL_BASIC_P"
    _shape  = "P"
  }

  Hall_Basic_I_Stair =
  {
    _prefab = "HALL_BASIC_I_STAIR"
    _shape  = "IS"
  }

  Hall_Basic_I_Lift =
  {
    _prefab = "HALL_BASIC_I_LIFT_QUAKE"
    _shape  = "IL"
    _tags   = 1

    lift = "MET5_1"
  }


  Sky_Hall_I =
  {
    _prefab = "SKY_HALL_I"
    _shape  = "I"
    _need_sky = 1
  }

  Sky_Hall_C =
  {
    _prefab = "SKY_HALL_C"
    _shape  = "C"
    _need_sky = 1

    support = "METAL1_1"
    torch_ent = "globe"
  }

  Sky_Hall_I_Stair =
  {
    _prefab = "SKY_HALL_I_STAIR"
    _shape  = "IS"
    _need_sky = 1

--??    step = "STEP5"
  }



  ---| BIG JUNCTIONS |---

  Junc_Octo_I =
  {
    _prefab = "JUNCTION_OCTO"
    _shape  = "I"

    hole = "WINDOW1_3"

    east_wall_q = 1
    west_wall_q = 1
  }

  Junc_Octo_C =
  {
    _prefab = "JUNCTION_OCTO"
    _shape  = "C"

    hole = "WINDOW1_3"

    north_wall_q = 1
     east_wall_q = 1
  }

  Junc_Octo_T =
  {
    _prefab = "JUNCTION_OCTO"
    _shape  = "T"

    hole = "WINDOW1_3"

    north_wall_q = 1
  }

  Junc_Octo_P =
  {
    _prefab = "JUNCTION_OCTO"
    _shape  = "P"

    hole = "WINDOW1_3"

    -- leave all walls open
  }


  ---| TELEPORTERS |---

  Teleporter1 =
  {
    _prefab = "QUAKE_TELEPORTER"
    _where  = "middle"

    frame = "MET5_1"
  }


  ---| WINDOWS |---

  Window1 =
  {
    _prefab = "WINDOW"
    _where  = "edge"
    _long   = 192
    _deep   = 32

    track = "RUNE2_2"
  }


  ---| FENCES |---

  Fence1 =
  {
    _prefab = "FENCE_STICKS_QUAKE"
    _where  = "edge"
    _long   = 192
    _deep   = 32

    fence = "WIZWOOD1_8"
    metal = "METAL1_1"
  }


  ---| CAGES |---

  Fat_Cage_W_Bars =
  {
    _prefab = "FAT_CAGE_W_BARS"
    _where  = "chunk"

    bar = "METAL1_1"
  }


  ---| DECORATION |---

  TechLamp =
  {
    _prefab = "QUAKE_TECHLAMP"
    _radius = 24
  }

  RoundPillar =
  {
    _prefab = "ROUND_PILLAR"
    _radius = 32

    pillar = "TECH02_5"
  }

} -- end of QUAKE.SKINS


----------------------------------------------------------------

QUAKE.THEME_DEFAULTS =
{
  starts = { Start_basic = 50 }

  exits = { Exit_basic = 50 }

  stairs = { Stair_Up1 = 50, Stair_Down1 = 50,
              Lift_Up1 =  3,  Lift_Down1 =  3 }

  pedestals = { Pedestal_tech = 50 }

  keys = { k_silver=60, k_gold=20 }

  switches = { sw_foo=50 }

  switch_fabs = { Switch_floor1 = 50 }

  locked_doors =
  {
    Locked_silver = 50
    Locked_gold = 50
    Locked_silver_wide = 900
    Locked_gold_wide = 900

    Door_SW_1 = 50
  }

  arches = { Arch1 = 50 }

  doors = { Door_plain = 50 }

  teleporters = { Teleporter1 = 50 }

  hallway_groups = { basic = 50 }

  mini_halls = { Hall_Basic_I = 50 }

  sky_halls = { skier = 50 }

  big_junctions =
  {
    Junc_Octo = 50
  }

  logos = { Pic_Carve = 50, Pic_Bolt = 100 }



  windows = { Window1 = 50 }

  fences = { Fence1 = 50 }

  fat_cages = { Fat_Cage_W_Bars = 50 }

  indoor_fabs = { TechLamp = 50, RoundPillar = 50 }

  --------- OLD CRUD --------> > >

  tele_dest_mat = "COP3_4",
}


QUAKE.NAME_THEMES =
{
  -- TODO
}


QUAKE.HALLWAY_GROUPS =
{
  basic =
  {
    pieces =
    {
      Hall_Basic_I = 50
      Hall_Basic_C = 50
      Hall_Basic_T = 50
      Hall_Basic_P = 50

      Hall_Basic_I_Stair = 20
      Hall_Basic_I_Lift  = 2
    }
  }

  skier =
  {
    pieces =
    {
      Sky_Hall_I = 50
      Sky_Hall_C = 50
      Sky_Hall_I_Stair = 50

      Hall_Basic_T = 50  -- use indoor versions for these
      Hall_Basic_P = 50  --

      Hall_Basic_I_Lift = 2   -- TODO: sky version
    }
  }
}


QUAKE.ROOM_THEMES =
{
  Base_generic =
  {
    walls =
    {
      TECH06_1=50, TECH08_2=50, TECH09_3=50, TECH08_1=50,
      TECH13_2=50, TECH14_1=50, TWALL1_4=50, TECH14_2=50,
      TWALL2_3=50, TECH03_1=50, TECH05_1=50,
    }

    floors =
    {
      FLOOR01_5=50, METAL2_4=50, METFLOR2_1=50, MMETAL1_1=50,
      SFLOOR4_1=50, SFLOOR4_5=50, SFLOOR4_6=50, SFLOOR4_7=50,
      WIZMET1_2=50, MMETAL1_6=50, MMETAL1_7=50, MMETAL1_8=50,
      WMET4_5=50, WMET1_1=50, 
    }

    ceilings =
    {
      FLOOR01_5=50, METAL2_4=50, METFLOR2_1=50, MMETAL1_1=50,
      SFLOOR4_1=50, SFLOOR4_5=50, SFLOOR4_6=50, SFLOOR4_7=50,
      WIZMET1_2=50, MMETAL1_6=50, MMETAL1_7=50, MMETAL1_8=50,
      WMET4_5=50, WMET1_1=50,
    }
  }


  Castle_generic =
  {
    walls =
    {
      BRICKA2_4=30, CITY5_4=30, WALL14_5=30, CITY1_4=30, METAL4_4=20, METALT1_1=15,
      CITY5_8=40, CITY5_7=50, CITY6_3=50, CITY6_4=50, METAL4_3=20, METALT2_2=5,
      CITY2_1=30, CITY2_2=30, CITY2_3=30, CITY2_5=30, METAL4_2=15, METALT2_3=20,
      CITY2_6=30, CITY2_7=30, CITY2_8=30, CITY6_7=20, METAL4_7=20, METALT2_6=5,
      CITY8_2=30, WALL3_4=30, WALL5_4=30, WBRICK1_5=30, METAL4_8=20, METALT2_7=20, WMET4_8=15,
      WIZ1_4=30, WSWAMP1_4=30, WSWAMP2_1=30, WSWAMP2_2=30, ALTARC_1=20, WMET4_3=15, WMET4_7=15,
      WWALL1_1=30, WALL3_4=30, ALTAR1_3=20, ALTAR1_6=5, ALTAR1_7=20, WMET4_4=15, WMET4_6=15,
    }

    floors =
    {
      AFLOOR1_4=50, AFLOOR3_1=25, AZFLOOR1_1=20, ROCK3_8=20, METAL5_4=30, FLOOR01_5=30,
      CITY4_1=15, CITY4_2=25, CITY4_5=15, CITY4_6=20, ROCK3_7=20, METAL5_2=30, MMETAL1_2=15,
      CITY4_7=15, CITY4_8=15, CITY5_1=30, CITY5_2=30, WALL3_4=30, CITY6_8=20,
      CITY8_2=20, GROUND1_8=20, ROCK3_7=20, AFLOOR1_3=20, BRICKA2_4=30, WALL9_8=30,
      AFLOOR1_8=20, WOODFLR1_5=20, BRICKA2_1=30, BRICKA2_2=30, CITY6_7=20, WOODFLR1_5=30,
    }

    ceilings =
    {
      DUNG01_4=50, DUNG01_5=50, ECOP1_8=50, ECOP1_4=50, ECOP1_6=50, WSWAMP1_4=30,
      WIZMET1_1=50, WIZMET1_4=50, WIZMET1_6=50, WIZMET1_7=50, WIZ1_1=50, WSWAMP2_1=30,
      GRAVE01_1=50, GRAVE01_3=50, GRAVE03_2=50, WALL3_4=30, WALL5_4=30, WALL11_2=20,
      WSWAMP2_2=30, WBRICK1_5=30, WIZ1_4=20, COP1_1=30, COP1_2=30, COP1_8=30, COP2_2=30,
      MET5_1=20, METAL1_1=20, METAL1_2=20, METAL1_3=20, WMET1_1=15,
    }
  }


  Cave_generic =
  {
    naturals =
    {
      ROCK1_2=10, ROCK5_2=40, ROCK3_8=20,
      WALL11_2=10, GROUND1_6=10, GROUND1_7=10,
      GRAVE01_3=10, WSWAMP1_2=20, 
    }
  }


  Outdoors_generic =
  {
    floors =
    {
      CITY4_6=30, CITY6_7=30, 
      CITY4_5=30, CITY4_8=30, CITY6_8=30,
      WALL14_6=20, CITY4_1=30, CITY4_2=30, CITY4_7=30,
    }

    naturals =
    {
      GROUND1_2=50, GROUND1_5=50, GROUND1_6=20,
      GROUND1_7=30, GROUND1_8=20,
      ROCK3_7=50, ROCK3_8=50, ROCK4_2=50,
      VINE1_2=50, 
    }
  }
}


QUAKE.LEVEL_THEMES =
{
  quake_base1 =
  {
    prob = 50

    worldtype = 2

    skies = { sky1=20, sky4=80 }

    liquids = { slime0=25, slime=50 }

    buildings = { Base_generic=50 }

    -- hallways = { blah }

    caves = { Cave_generic=50 }

    outdoors = { Outdoors_generic=50 }

    pictures =
    {
      Pic_Computer1 = 40
      Pic_Computer2 = 40
      Pic_Light07 = 70
      Pic_Light03 = 20
    }


    -- TODO: lots more stuff...
  }


  quake_castle1 =
  {
    prob = 50

    worldtype = 0

    skies = { sky1=80, sky4=20 }

    liquids = { lava1=50 }

    buildings = { Castle_generic=50 }

    -- hallways = { blah }

    caves = { Cave_generic=50 }

    outdoors = { Outdoors_generic=50 }

    mini_halls = { MiniHall_Arch1 = 50 }

    pedestals = { Pedestal_gothic=50 }

    pictures =
    {
      Pic_StainGlass  = 60
      Pic_StainGlass2 = 10
      Pic_WoodCarve = 10
      Pic_Window3 = 30

      Pic_Demon = 20
      Pic_DemonLit = 20
      Pic_BloodyHead = 20
      Pic_YellowLight3 = 20
      Pic_CrossLight = 20
    }


    -- TODO: lots more stuff...
  }
}


----------------------------------------------------------------

QUAKE.MONSTERS =
{
  dog =
  {
    id = "monster_dog"
    r = 32  -- dogs are fat!
    h = 80 
    -- we use 'replaces' here to simulate the way dogs
    -- usually appear with grunts.
    replaces = "grunt"
    replace_prob = 30
    crazy_prob = 20
    health = 25
    damage = 8
    attack = "melee"
  }

  fish =
  {
    id = "monster_fish"
    r = 16
    h = 80 
    -- only appears in water
    health = 25
    damage = 3
    attack = "melee"
    weap_prefs = { grenade=0.2 }
  }

  grunt =
  {
    id = "monster_army"
    r = 16
    h = 80 
    level = 1
    prob = 80
    health = 30
    damage = 14
    attack = "hitscan"
    give = { {ammo="shell",count=5} }
    infights = true
  }

  enforcer =
  {
    id = "monster_enforcer"
    r = 16
    h = 80 
    level = 2
    prob = 40
    health = 80
    damage = 18
    attack = "missile"
    give = { {ammo="cell",count=5} }
    density  =  0.5
  }

  zombie =
  {
    id = "monster_zombie"
    r = 16
    h = 80 
    level = 2
    prob = 40
    health = 60
    damage = 8
    attack = "melee"
    weap_needed = { grenade=1,rocket=1 }
    weap_prefs = { grenade=99,rocket=99 }
  }

  scrag =
  {
    id = "monster_wizard"
    r = 16
    h = 80 
    level = 2
    prob = 60
    health = 80
    damage = 18
    attack = "missile"
    weap_prefs = { grenade=0.2 }
  }

  tarbaby =
  {
    id = "monster_tarbaby"
    r = 16
    h = 80 
    level = 3
    prob = 1
    health = 80
    damage = 30
    attack = "melee"
    density = 0.3
    weap_prefs = { rocket=0.2,grenade=0.2 }
  }

  knight =
  {
    id = "monster_knight"
    r = 16
    h = 80 
    level = 1
    prob = 60
    density  =  0.6
    health = 75
    damage = 15
    attack = "melee"
  }

  death_kt =
  {
    id = "monster_hell_knight"
    r = 32
    h = 80 
    level = 5
    prob = 30
    density  =  0.4
    health = 250
    damage = 30
    attack = "missile"
  }

  ogre =
  {
    id = "monster_ogre"
    r = 32
    h = 80 
    level = 3
    prob = 40
    health = 200
    damage = 25
    attack = "missile"
    give = { {ammo="rocket",count=2} }
    density  =  0.4
  }

  fiend =
  {
    id = "monster_demon1"
    r = 32
    h = 80 
    level = 4
    prob = 10
    health = 300
    damage = 40
    attack = "melee"
    density  =  0.3
    weap_prefs = { grenade=0.2 }
  }

  vore =
  {
    id = "monster_shalrath"
    r = 32
    h = 80 
    level = 7
    prob = 10
    health = 400
    damage = 60
    attack = "missile"
    density  =  0.2
  }

  shambler =
  {
    id = "monster_shambler"
    r = 32
    h = 80 
    level = 7
    prob = 10
    health = 600
    damage = 50
    attack = "hitscan"
    immunity   = { rocket=0.5,grenade=0.5 }
    weap_prefs = { rocket=0.2,grenade=0.2 }
    density  =  0.2
  }
}


QUAKE.WEAPONS =
{
  axe =
  {
    attack = "melee"
    rate = 2.0
    damage = 20
  }

  pistol =
  {
    pref = 10
    attack = "hitscan"
    rate = 2.0
    damage = 20
    ammo = "shell"
    per = 1
  }

  ssg =
  {
    id = "weapon_supershotgun"
    level = 2
    add_prob = 40
    start_prob = 50
    pref = 50
    attack = "hitscan"
    rate = 1.4
    damage = 45
    splash = {0,3}
    ammo = "shell"
    per = 2
    give = { {ammo="shell",count=5} }
  }

  grenade =
  {
    id = "weapon_grenadelauncher"
    level = 3
    add_prob = 15
    start_prob = 15
    pref = 12
    attack = "missile"
    rate = 1.5
    damage = 5
    splash = {60,15,3}
    ammo = "rocket"
    per = 1
    give = { {ammo="rocket",count=5} }
  }

  rocket =
  {
    id = "weapon_rocketlauncher"
    level = 5
    add_prob = 10
    start_prob = 10
    pref = 30
    attack = "missile"
    rate = 1.2
    damage = 80
    splash = {0,20,6,2}
    ammo = "rocket"
    per = 1
    give = { {ammo="rocket",count=5} }
  }

  nailgun =
  {
    id = "weapon_nailgun"
    level = 1
    add_prob = 30
    start_prob = 50
    pref = 50
    attack = "missile"
    rate = 5.0
    damage = 8
    ammo = "nail"
    per = 1
    give = { {ammo="nail",count=30} }
  }

  nailgun2 =
  {
    id = "weapon_supernailgun"
    level = 3
    add_prob = 10
    start_prob = 15
    pref = 80
    attack = "missile"
    rate = 5.0
    damage = 18
    ammo = "nail"
    per = 2
    give = { {ammo="nail",count=30} }
  }

  zapper =
  {
    id = "weapon_lightning"
    level = 5
    add_prob = 25
    start_prob = 5
    pref = 30
    attack = "hitscan"
    rate = 10
    damage = 30
    splash = {0,4}
    ammo = "cell"
    per = 1
    give = { {ammo="cell",count=15} }
  }


  -- NOTES:
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


QUAKE.PICKUPS =
{
  -- HEALTH --

  heal_10 =
  {
    id = "item_health"
    spawnflags = 1
    prob = 20
    cluster = { 1,2 }
    give = { {health=8} }   -- real amount is 5-10 units
  }

  heal_25 =
  {
    id = "item_health"
    spawnflags = 0
    prob = 50
    give = { {health=25} }
  }

  mega =
  {
    id = "item_health"
    spawnflags = 2
    prob = 3
    big_item = true
    give = { {health=70} }  -- gives 100 but it rots aways
  }

  -- ARMOR --

  green_armor =
  {
    id = "item_armor1"
    prob = 9
    give = { {health=30} }
  }

  yellow_armor =
  {
    id = "item_armor2"
    prob = 3
    give = { {health=90} }
  }

  red_armor =
  {
    id = "item_armorInv"
    prob = 1
    give = { {health=160} }
  }

  -- AMMO --

  shell_20 =
  {
    id = "item_shells"
    spawnflags = 0
    prob = 10
    give = { {ammo="shell",count=20} }
  }

  shell_40 =
  {
    id = "item_shells"
    spawnflags = 1
    prob = 20
    give = { {ammo="shell",count=40} }
  }

  nail_25 =
  {
    id = "item_spikes"
    spawnflags = 0
    prob = 10
    give = { {ammo="nail",count=25} }
  }

  nail_50 =
  {
    id = "item_spikes"
    spawnflags = 1
    prob = 20
    give = { {ammo="nail",count=50} }
  }

  rocket_5 =
  {
    id = "item_rockets"
    spawnflags = 0
    prob = 10
    give = { {ammo="rocket",count=5} }
  }

  rocket_10 =
  {
    id = "item_rockets"
    spawnflags = 1
    prob = 20
    give = { {ammo="rocket",count=10} }
  }

  cell_6 =
  {
    id = "item_cells"
    spawnflags = 0
    prob = 10
    give = { {ammo="cell",count=6} }
  }

  cell_12 =
  {
    id = "item_cells"
    spawnflags = 1
    prob = 20
    give = { {ammo="cell",count=12} }
  }
}


QUAKE.PLAYER_MODEL =
{
  quakeguy =
  {
    stats   = { health=0 }
    weapons = { pistol=1, axe=1 }
  }
}


------------------------------------------------------------

QUAKE.EPISODES =
{
  episode1 =
  {
    theme = "TECH"
    sky_light = 0.75
  }

  episode2 =
  {
    theme = "TECH"
    sky_light = 0.75
  }

  episode3 =
  {
    theme = "TECH"
    sky_light = 0.75
  }

  episode4 =
  {
    theme = "TECH"
    sky_light = 0.75
  }
}


----------------------------------------------------------------

function QUAKE.setup()
  -- nothing needed
end


function QUAKE.get_levels()
  local  EP_NUM = (OB_CONFIG.length == "full"   ? 4 ; 1)
  local MAP_NUM = (OB_CONFIG.length == "single" ? 1 ; 7)

  if OB_CONFIG.length == "few"     then MAP_NUM = 3 end
  if OB_CONFIG.length == "episode" then MAP_NUM = 6 end

  local SKIP_MAPS =
  {
    -- not present in original
    e2m7 = 1, e3m7 = 1,

    -- boss maps
    e1m7 = 2, e2m6 = 2,
    e3m6 = 2, e4m7 = 2,
  }

  for ep_index = 1,EP_NUM do
    -- create episode info...
    local EPI =
    {
      levels = {}
    }

    table.insert(GAME.episodes, EPI)

    local ep_info = QUAKE.EPISODES["episode" .. ep_index]
    assert(ep_info)

    for map = 1,MAP_NUM do
      local name = string.format("e%dm%d", ep_index, map)

      -- create level info....
      local LEV =
      {
        episode = EPI

        name = name
        next_map = string.format("e%dm%d", ep_index, map+1)

         ep_along = map / MAP_NUM
        mon_along = (map + ep_index - 1) / MAP_NUM
      }

      if SKIP_MAPS[name] then
        continue
      end

      table.insert( EPI.levels, LEV)
      table.insert(GAME.levels, LEV)

    end -- for map

  end -- for episode
end


function QUAKE.begin_level()
  -- find the texture wad
  local primary_tex_wad = gui.locate_data("quake_tex.wd2")

  if not primary_tex_wad then
    error("cannot find texture file: quake_tex.wd2\n\n" ..
          "Please visit the following link which takes you to the " ..
          "Quake Setup documentation on the OBLIGE website: " ..
          "<a http://oblige.sourceforge.net/doc_usage.html#quake>Setting Up Quake</a>")
  end

  gui.q1_add_tex_wad(primary_tex_wad)

  -- set worldtype (controls the way keys look, doors sound, etc)
  gui.property("worldtype", LEVEL.theme.worldtype)

  -- select the sky to use
  assert(LEVEL.theme.skies)
  GAME.MATERIALS["_SKY"].t = rand.key_by_probs(LEVEL.theme.skies)
end


----------------------------------------------------------------

UNFINISHED["quake"] =
{
  label = "Quake"

  format = "quake"

  tables =
  {
    QUAKE
  }

  hooks =
  {
    setup        = QUAKE.setup
    get_levels   = QUAKE.get_levels
    begin_level  = QUAKE.begin_level
  }
}


OB_THEMES["quake_base"] =
{
  label = "Base"
  for_games = { quake=1 }
  name_theme = "TECH"
  mixed_prob = 50
}

OB_THEMES["quake_castle"] =
{
  label = "Castle"
  for_games = { quake=1 }
  name_theme = "URBAN"
  mixed_prob = 50
}

