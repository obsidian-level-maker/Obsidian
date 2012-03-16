----------------------------------------------------------------
-- GAME DEF : Heretic
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2012 Andrew Apted
--  Copyright (C)      2008 Sam Trenholme
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

HERETIC = { }

HERETIC.ENTITIES =
{
  --- player stuff ---
  player1 = { id=1, kind="other", r=16,h=56 }
  player2 = { id=2, kind="other", r=16,h=56 }
  player3 = { id=3, kind="other", r=16,h=56 }
  player4 = { id=4, kind="other", r=16,h=56 }

  dm_player     = { id=11, kind="other", r=16,h=56 }
  teleport_spot = { id=14, kind="other", r=16,h=56 }

  --- monsters ---
  gargoyle   = { id=66, kind="monster", r=16,h=36 }
  fire_garg  = { id=5,  kind="monster", r=16,h=36 }
  mummy      = { id=68, kind="monster", r=22,h=64 }
  mummy_inv  = { id=69, kind="monster", r=22,h=64 }

  leader     = { id=45, kind="monster", r=22,h=64 }
  leader_inv = { id=46, kind="monster", r=22,h=64 }
  knight     = { id=64, kind="monster", r=24,h=80 }
  knight_inv = { id=65, kind="monster", r=24,h=80 }

  disciple   = { id=15, kind="monster", r=16,h=72 }
  sabreclaw  = { id=90, kind="monster", r=20,h=64 }
  weredragon = { id=70, kind="monster", r=34,h=80 }
  ophidian   = { id=92, kind="monster", r=22,h=72 }

  --- bosses ---
  Ironlich   = { id=6,  kind="monster", r=40,h=72 }
  Maulotaur  = { id=9,  kind="monster", r=28,h=104 }
  D_Sparil   = { id=7,  kind="monster", r=28,h=104 }

  --- keys ---
  k_yellow   = { id=80, kind="pickup", r=20,h=16, pass=true }
  k_green    = { id=73, kind="pickup", r=20,h=16, pass=true }
  k_blue     = { id=79, kind="pickup", r=20,h=16, pass=true }

  --- weapons ---
  gauntlets  = { id=2005, kind="pickup", r=20,h=16, pass=true }
  crossbow   = { id=2001, kind="pickup", r=20,h=16, pass=true }
  claw       = { id=53,   kind="pickup", r=20,h=16, pass=true }
  hellstaff  = { id=2004, kind="pickup", r=20,h=16, pass=true }
  phoenix    = { id=2003, kind="pickup", r=20,h=16, pass=true }
  firemace   = { id=2002, kind="pickup", r=20,h=16, pass=true }

  --- ammo ---
  crystal    = { id=10, kind="pickup", r=20,h=16, pass=true }
  geode      = { id=12, kind="pickup", r=20,h=16, pass=true }
  arrow      = { id=18, kind="pickup", r=20,h=16, pass=true }
  quiver     = { id=19, kind="pickup", r=20,h=16, pass=true }
  claw_orb1  = { id=54, kind="pickup", r=20,h=16, pass=true }
  claw_orb2  = { id=55, kind="pickup", r=20,h=16, pass=true }
  runes1     = { id=20, kind="pickup", r=20,h=16, pass=true }
  runes2     = { id=21, kind="pickup", r=20,h=16, pass=true }
  flame_orb1 = { id=22, kind="pickup", r=20,h=16, pass=true }
  flame_orb2 = { id=23, kind="pickup", r=20,h=16, pass=true }
  mace_orb1  = { id=13, kind="pickup", r=20,h=16, pass=true }
  mace_orb2  = { id=16, kind="pickup", r=20,h=16, pass=true }

  --- health ---
  h_vial  = { id=81, kind="pickup", r=20,h=16, pass=true }
  h_flask = { id=82, kind="pickup", r=20,h=16, pass=true }
  h_urn   = { id=32, kind="pickup", r=20,h=16, pass=true }
  shield1 = { id=85, kind="pickup", r=20,h=16, pass=true }
  shield2 = { id=31, kind="pickup", r=20,h=16, pass=true }

  --- powerups ---
  bag     = { id=8,  kind="pickup", r=20,h=16, pass=true }
  wings   = { id=83, kind="pickup", r=20,h=16, pass=true }
  ovum    = { id=30, kind="pickup", r=20,h=16, pass=true }
  torch   = { id=33, kind="pickup", r=20,h=16, pass=true }
  bomb    = { id=34, kind="pickup", r=20,h=16, pass=true }
  map     = { id=35, kind="pickup", r=20,h=16, pass=true }
  chaos   = { id=36, kind="pickup", r=20,h=16, pass=true }
  shadow  = { id=75, kind="pickup", r=20,h=16, pass=true }
  ring    = { id=84, kind="pickup", r=20,h=16, pass=true }
  tome    = { id=86, kind="pickup", r=20,h=16, pass=true }

  --- scenery ---
  wall_torch    = { id=50, kind="scenery", r=10,h=64, light=255, pass=true, add_mode="extend" }
  serpent_torch = { id=27, kind="scenery", r=12,h=54, light=255 }
  fire_brazier  = { id=76, kind="scenery", r=16,h=44, light=255 }
  chandelier    = { id=28, kind="scenery", r=31,h=60, light=255, pass=true, ceil=true, add_mode="island" }

  barrel  = { id=44,   kind="scenery", r=12,h=32 }
  pod     = { id=2035, kind="scenery", r=16,h=54 }

  blue_statue   = { id=94, kind="scenery", r=16,h=54 }
  green_statue  = { id=95, kind="scenery", r=16,h=54 }
  yellow_statue = { id=96, kind="scenery", r=16,h=54 }

  moss1   = { id=48, kind="scenery", r=16,h=24, ceil=true, pass=true }
  moss2   = { id=49, kind="scenery", r=16,h=28, ceil=true, pass=true }
  volcano = { id=87, kind="scenery", r=12,h=32 }
  
  small_pillar = { id=29, kind="scenery", r=16,h=36 }
  brown_pillar = { id=47, kind="scenery", r=16,h=128 }
  glitter_red  = { id=74, kind="scenery", r=20,h=16, pass=true }
  glitter_blue = { id=52, kind="scenery", r=20,h=16, pass=true }

  stal_small_F = { id=37, kind="scenery", r=12,h=36 }
  stal_small_C = { id=39, kind="scenery", r=16,h=36, ceil=true }
  stal_big_F   = { id=38, kind="scenery", r=12,h=72 }
  stal_big_C   = { id=40, kind="scenery", r=16,h=72, ceil=true }

  hang_skull_1 = { id=17, kind="scenery", r=20,h=64, ceil=true, pass=true }
  hang_skull_2 = { id=24, kind="scenery", r=20,h=64, ceil=true, pass=true }
  hang_skull_3 = { id=25, kind="scenery", r=20,h=64, ceil=true, pass=true }
  hang_skull_4 = { id=26, kind="scenery", r=20,h=64, ceil=true, pass=true }
  hang_corpse  = { id=51, kind="scenery", r=12,h=104,ceil=true }

  --- miscellaneous ---
  dummy = { id=49, kind="other", r=16,h=20, pass=true }

  --- ambient sounds ---
  amb_scream = { id=1200, kind="other", r=20,h=16, pass=true }
  amb_squish = { id=1201, kind="other", r=20,h=16, pass=true }
  amb_drip   = { id=1202, kind="other", r=20,h=16, pass=true }
  amb_feet   = { id=1203, kind="other", r=20,h=16, pass=true }
  amb_heart  = { id=1204, kind="other", r=20,h=16, pass=true }
  amb_bells  = { id=1205, kind="other", r=20,h=16, pass=true }
  amb_growl  = { id=1206, kind="other", r=20,h=16, pass=true }
  amb_magic  = { id=1207, kind="other", r=20,h=16, pass=true }
  amb_laugh  = { id=1208, kind="other", r=20,h=16, pass=true }
  amb_run    = { id=1209, kind="other", r=20,h=16, pass=true }

  env_water  = { id=41, kind="other", r=20,h=16, pass=true }
  env_wind   = { id=42, kind="other", r=20,h=16, pass=true }
}


HERETIC.PARAMETERS =
{
  rails = true
  infighting  =  true
  prefer_stairs = true
  light_brushes = true

  jump_height = 24

  max_name_length = 28

  skip_monsters = { 20,30 }

  time_factor   = 1.0
  damage_factor = 1.0
  ammo_factor   = 0.8
  health_factor = 0.7
}


----------------------------------------------------------------

HERETIC.MATERIALS =
{
  -- special materials --

  _ERROR = { t="WOODWL",  f="FLOOR10" }
  _SKY   = { t="CHAINSD", f="F_SKY1"  }

  -- general purpose --

  -- walls --

  BANNER1  = { t="BANNER1",  f="FLOOR03", color=0x3a2b3c }
  BANNER2  = { t="BANNER2",  f="FLOOR03", color=0x3c213b }
  BANNER3  = { t="BANNER3",  f="FLAT520", color=0x4f2318 }
  BANNER4  = { t="BANNER4",  f="FLAT520", color=0x222039 }
  BANNER5  = { t="BANNER5",  f="FLOOR25", color=0x662c0f }
  BANNER6  = { t="BANNER6",  f="FLOOR25", color=0x392831 }
  BANNER7  = { t="BANNER7",  f="FLOOR00", color=0x3d2d3e }
  BANNER8  = { t="BANNER8",  f="FLOOR00", color=0x3f243e }
  BLUEFRAG = { t="BLUEFRAG", f="FLOOR16", color=0x00043b }
  BRWNRCKS = { t="BRWNRCKS", f="FLOOR17", color=0x40200f }

  CELTIC   = { t="CELTIC",   f="FLOOR06", color=0x694429 }
  CHAINMAN = { t="CHAINMAN", f="FLAT520", color=0x39332e }
  CSTLMOSS = { t="CSTLMOSS", f="FLOOR03", color=0x2e302d }
  CSTLRCK  = { t="CSTLRCK",  f="FLOOR03", color=0x313131 }
  CTYSTCI1 = { t="CTYSTCI1", f="FLOOR11", color=0x3f3527 }
  CTYSTCI2 = { t="CTYSTCI2", f="FLOOR11", color=0x40372a }
  CTYSTCI4 = { t="CTYSTCI4", f="FLOOR11", color=0x41392f }
  CTYSTUC1 = { t="CTYSTUC1", f="FLOOR11", color=0x322b25 }
  CTYSTUC2 = { t="CTYSTUC2", f="FLOOR11", color=0x37322d }
  CTYSTUC3 = { t="CTYSTUC3", f="FLOOR11", color=0x312a24 }
  CTYSTUC4 = { t="CTYSTUC4", f="FLOOR11", color=0x393530 }
  CTYSTUC5 = { t="CTYSTUC5", f="FLOOR11", color=0x302823 }

  DMNMSK   = { t="DMNMSK",   f="FLAT521", color=0x5c5d5c }
  DOOREXIT = { t="DOOREXIT", f="FLAT520", color=0x3a3b43 }
  DOORSTON = { t="DOORSTON", f="FLOOR30", color=0x2b2b29 }
  DOORWOOD = { t="DOORWOOD", f="FLAT507", color=0x302119 }
  DRIPWALL = { t="DRIPWALL", f="FLOOR27", color=0x664c2a }

  GRNBLOK1 = { t="GRNBLOK1", f="FLOOR19", color=0x2c392b }
  GRNBLOK2 = { t="GRNBLOK2", f="FLOOR19", color=0x2a372a }
  GRNBLOK3 = { t="GRNBLOK3", f="FLOOR19", color=0x2c392b }
  GRNBLOK4 = { t="GRNBLOK4", f="FLOOR19", color=0x2b3729 }
  GRSKULL1 = { t="GRSKULL1", f="FLAT521", color=0x62605e }
  GRSKULL2 = { t="GRSKULL2", f="FLAT521", color=0x686765 }
  GRSKULL3 = { t="GRSKULL3", f="FLAT521", color=0x716f6e }
  GRSTNPB  = { t="GRSTNPB",  f="FLAT520", color=0x2c2926 }
  GRSTNPBV = { t="GRSTNPBV", f="FLAT520", color=0x302e2b }
  GRSTNPBW = { t="GRSTNPBW", f="FLAT520", color=0x2f2c28 }
  HORSES1  = { t="HORSES1",  f="FLAT520", color=0x343833 }

  LOOSERCK = { t="LOOSERCK", f="FLOOR04", color=0x2b2b29 }
  METL1    = { t="METL1",    f="FLOOR29", color=0x171717 }
  METL2    = { t="METL2",    f="FLOOR28", color=0x191919 }
  MOSAIC1  = { t="MOSAIC1",  f="FLAT502", color=0x3a5dc9 }
  MOSAIC2  = { t="MOSAIC2",  f="FLAT502", color=0x4062c1 }
  MOSAIC3  = { t="MOSAIC3",  f="FLAT502", color=0x3c63c0 }
  MOSAIC4  = { t="MOSAIC4",  f="FLAT502", color=0x3c5ec6 }
  MOSAIC5  = { t="MOSAIC5",  f="FLAT502", color=0x3e60c4 }
  MOSSRCK1 = { t="MOSSRCK1", f="FLOOR05", color=0x2c3a29 }

  ORNGRAY  = { t="ORNGRAY",  f="FLAT504", color=0x3e3e3e }
  RCKSNMUD = { t="RCKSNMUD", f="FLOOR01", color=0x49321a }
  REDWALL  = { t="REDWALL",  f="FLOOR09", color=0x5f0000 }
  ROOTWALL = { t="ROOTWALL", f="FLAT506", color=0x4b311f }

  SAINT1   = { t="SAINT1",   f="FLAT523", color=0x2a2a2a }
  SANDSQ2  = { t="SANDSQ2",  f="FLOOR06", color=0x6f4f2a }
  SKULLSB1 = { t="SKULLSB1", f="FLOOR30", color=0x202020 }
  SNDBLCKS = { t="SNDBLCKS", f="FLOOR06", color=0x4e3515 }
  SNDCHNKS = { t="SNDCHNKS", f="FLAT522", color=0x6b3c1e }
  SNDPLAIN = { t="SNDPLAIN", f="FLOOR25", color=0x4b3114 }
  SPINE1   = { t="SPINE1",   f="FLOOR25", color=0x4b3214 }
  SPINE2   = { t="SPINE2",   f="FLOOR25", color=0x513616 }

  SQPEB1   = { t="SQPEB1",   f="FLAT504", color=0x474846 }
  SQPEB2   = { t="SQPEB2",   f="FLOOR27", color=0x4a2610 }
  STNGLS1  = { t="STNGLS1",  f="FLOOR30", color=0x4b2745 }
  STNGLS2  = { t="STNGLS2",  f="FLOOR30", color=0x3c1d3f }
  STNGLS3  = { t="STNGLS3",  f="FLOOR30", color=0x31202d }

  TMBSTON1 = { t="TMBSTON1", f="FLAT521", color=0x40413f }
  TMBSTON2 = { t="TMBSTON2", f="FLAT521", color=0x3d3f3d }
  TRISTON1 = { t="TRISTON1", f="FLOOR00", color=0x343434 }
  TRISTON2 = { t="TRISTON2", f="FLOOR17", color=0x4f2b15 }
  WOODWL   = { t="WOODWL",   f="FLOOR10", color=0x42210f }

  -- switches --

  SW1OFF   = { t="SW1OFF",   f="FLOOR28" }
  SW1ON    = { t="SW1ON",    f="FLOOR28" }

  -- floors --

  FLAT500  = { f="FLAT500", t="SQPEB1",   color=0x574f49 }
  FLAT502  = { f="FLAT502", t="BLUEFRAG", color=0x030793 }
  FLAT503  = { f="FLAT503", t="SQPEB1",   color=0x4b4b4a }
  FLAT504  = { f="FLAT504", t="SQPEB1",   color=0x555754 }
  FLAT506  = { f="FLAT506", t="ROOTWALL", color=0x3d2b1f }
  FLAT507  = { f="FLAT507", t="DOORWOOD", color=0x292524 }
  FLAT508  = { f="FLAT508", t="DOORWOOD", color=0x3a2215 }
  FLAT509  = { f="FLAT509", t="LOOSERCK", color=0x494949 }
  FLAT510  = { f="FLAT510", t="BRWNRCKS", color=0x4b2c0b }

  FLAT512  = { f="FLAT512", t="GRNBLOK1", color=0x1c241b }
  FLAT513  = { f="FLAT513", t="GRNBLOK1", color=0x2d362c }
  FLAT516  = { f="FLAT516", t="LOOSERCK", color=0x2f2419 }
  FLAT517  = { f="FLAT517", t="BLUEFRAG", color=0x1f25c4 }
  FLAT520  = { f="FLAT520", t="CSTLRCK",  color=0x373837 }
  FLAT521  = { f="FLAT521", t="SQPEB1",   color=0x505050 }
  FLAT522  = { f="FLAT522", t="SNDCHNKS", color=0x7c4b28 }
  FLAT523  = { f="FLAT523", t="GRSTNPB",  color=0x262626 }

  FLOOR00  = { f="FLOOR00", t="TRISTON1", color=0x303030 }
  FLOOR01  = { f="FLOOR01", t="LOOSERCK", color=0x1b110b }
  FLOOR03  = { f="FLOOR03", t="CSTLRCK",  color=0x343434 }
  FLOOR04  = { f="FLOOR04", t="CSTLRCK",  color=0x393a39 }
  FLOOR05  = { f="FLOOR05", t="MOSSROCK", color=0x283e23 }
  FLOOR06  = { f="FLOOR06", t="SANDSQ2",  color=0x956139 }
  FLOOR07  = { f="FLOOR07", t="MOSAIC1",  color=0x676679 }
  FLOOR08  = { f="FLOOR08", t="CHAINSD",  color=0x2f2d2b }
  FLOOR09  = { f="FLOOR09", t="REDWALL",  color=0x6d0000 }
  FLOOR10  = { f="FLOOR10", t="WOODWL",   color=0x442b0e }
  FLOOR11  = { f="FLOOR11", t="WOODWL",   color=0x3c3428 }
  FLOOR12  = { f="FLOOR12", t="WOODWL",   color=0x372f26 }
  FLOOR16  = { f="FLOOR16", t="BLUEFRAG", color=0x00043b }
  FLOOR17  = { f="FLOOR17", t="BRWNRCKS", color=0x3e200e }
  FLOOR18  = { f="FLOOR18", t="GRNBLOK1", color=0x293828 }
  FLOOR19  = { f="FLOOR19", t="GRNBLOK1", color=0x334531 }

  FLOOR20  = { f="FLOOR20", t="SQPEB2",   color=0x4a2a17 }
  FLOOR21  = { f="FLOOR21", t="CHAINSD",  color=0x33343e }
  FLOOR22  = { f="FLOOR22", t="CHAINSD",  color=0x33343e }
  FLOOR23  = { f="FLOOR23", t="CHAINSD",  color=0x33343e }
  FLOOR24  = { f="FLOOR24", t="CHAINSD",  color=0x33343e }
  FLOOR25  = { f="FLOOR25", t="SPINE2",   color=0x513616 }
  FLOOR26  = { f="FLOOR26", t="CHAINSD",  color=0x282a44 }
  FLOOR27  = { f="FLOOR27", t="SANDSQ2",  color=0x644623 }
  FLOOR28  = { f="FLOOR28", t="METL2",    color=0x191919 }
  FLOOR29  = { f="FLOOR29", t="METL1",    color=0x171717 }
  FLOOR30  = { f="FLOOR30", t="METL1",    color=0x181818 }

  -- rails --

  WOODGATE = { t="WDGAT64", rail_h=64 }

  GATE_BIG = { t="GATMETL",  rail_h=128 }
  GATMETL2 = { t="GATMETL2", rail_h=32 }
  GATMETL3 = { t="GATMETL3", rail_h=32 }
  GATMETL4 = { t="GATMETL4", rail_h=64 }
  GATMETL5 = { t="GATMETL5", rail_h=128 }

  WEB1_B = { t="WEB1_B", rail_h=32 }
  WEB1_F = { t="WEB1_F", rail_h=32 }
  WEB2_B = { t="WEB2_B", rail_h=32 }
  WEB2_F = { t="WEB2_F", rail_h=32 }
  WEB3_M = { t="WEB3_M", rail_h=32 }

  -- liquids / animated --

  -- TODO: simplify this
  LAVA1    = { t="LAVA1",    f="FLAT506" }
  LAVAFL1  = { t="LAVAFL1",  f="FLATHUH1" }
  WATRWAL1 = { t="WATRWAL1", f="FLTFLWW1" }

  FLATHUH1 = { f="FLATHUH1", t="LAVAFL1"  }
  FLTFLWW1 = { f="FLTFLWW1", t="WATRWAL1" }
  FLTLAVA1 = { f="FLTLAVA1", t="LAVA1"    }
  FLTSLUD1 = { f="FLTSLUD1", t="LAVA1"    }
  FLTTELE1 = { f="FLTTELE1", t="CHAINSD"  }
  FLTWAWA1 = { f="FLTWAWA1", t="WATRWAL1" }

  -- other --

  O_PILL   = { t="SKULLSB2", f="O_PILL",  sane=1 }
  O_BOLT   = { t="DOORWOOD", f="O_BOLT",  sane=1 }
  O_CARVE  = { t="CHAINSD",  f="O_CARVE", sane=1 }
}


HERETIC.LIQUIDS =
{
  water  = { mat="FLTFLWW1", color=0x282fcc, light=0.65, special=0 }
  water2 = { mat="FLTWAWA1", color=0x282fcc, light=0.65, special=0 }
  sludge = { mat="FLTSLUD1", color=0x3e453d, light=0.65, special=16, damage=20 }
  lava   = { mat="FLATHUH1", color=0x851b00, light=0.75, special=16, damage=20 }
  magma  = { mat="FLTLAVA1", color=0x442b2b, light=0.65, special=16, damage=20 }
}



HERETIC.STEPS =  -- OLD STUFF
{
  step1 = { step_w="STEP1", side_w="BROWNHUG", top_f="FLOOR7_1" }
}


HERETIC.PICTURES =  -- OLD STUFF
{
  -- Note: this includes pictures that only work on DOOM1 or DOOM2.
  -- It is not a problem, because the game-specific sub-themes will
  -- only reference the appropriate entries.

  pill =
  {
    count=1,
    pic_w="O_PILL", width=128, height=32, raise=16,
    x_offset=0, y_offset=0,
    side_t="METL2", floor="FLOOR30", depth=8, 
    light=0.7,
  }

  carve =
  {
    count=1,
    pic_w="O_CARVE", width=64, height=64,
    x_offset=0, y_offset=0,
    side_t="METL2", floor="FLOOR30", depth=8, 
    light=0.7,
  }

}


----------------------------------------------------------------

HERETIC.SKINS =
{
  ----| STARTS |----

  Start_basic =
  {
    _prefab = "START_SPOT"

    top = "O_BOLT"
  }


  ----| EXITS |----

  Exit_switch =
  {
    _prefab = "EXIT_PILLAR",

    switch = "SW2OFF"
    exit = "MOSAIC1"
    exitside = "MOSAIC1"
    special = 11
    tag = 0
  }

  Exit_Closet =
  {
    _prefab = "EXIT_CLOSET"
    _where  = "closet"
    _size   = { 192,192, 384,384 }

    door  = "DOOREXIT"
    door_h = 96
    track = "METL2"
    key   = "METL2"

    inner  = "METL2"
    ceil   = "FLOOR19"
    floor2 = "FLOOR19"

    switch  = "SW2OFF"
    sw_side = "METL2"
    sw_oy   = 32

    q_sign = 0
    exit = "METL2"
    exitside = "METL2"

    special = 11
    tag = 0

    item2 = "h_vial"
  }



  ----| KEY |----

  Pedestal_1 =
  {
    _prefab = "PEDESTAL"
    _where  = "chunk"

    top  = "FLAT500"
    side = "SAINT1"
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


  Lift_Up1 =  -- Rusty
  {
    _prefab = "LIFT_UP"
    _where  = "chunk"
    _tags   = 1
    _deltas = { 96,128,160,192 }

    lift = "DOORSTON"
    top  = "FLOOR08"

    walk_kind   = 88
    switch_kind = 62
  }

  Lift_Down1 =  -- Shiny
  {
    _prefab = "LIFT_DOWN"
    _where  = "chunk"
    _tags   = 1
    _deltas = { -96,-128,-160,-192 }

    lift = "DOORSTON"
    top  = "FLOOR08"

    walk_kind   = 88
    switch_kind = 62
  }



  --- LOCKED DOORS ---

  Locked_yellow =
  {
    _prefab = "DOOR"   -- FIXME: heretic prefab with key statue
    _where  = "edge"
    _key    = "k_yellow"
    _long = 192
    _deep = 32

    w = 128
    h = 112
    door_h = 112
    door = "DOORSTON"
    track = "METL2"
    special = 34
    tag = 0  -- kind_mult=26

    statue_ent = "yellow_statue"
  }

  Locked_green =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _key    = "k_green"
    _long = 192
    _deep = 32

    w = 128
    h = 112
    door_h = 112
    door = "DOORSTON"
    track = "METL2"
    special = 33
    tag = 0  -- kind_mult=26

    statue_ent = "green_statue"
  }

  Locked_blue =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _key    = "k_blue"
    _long = 192
    _deep = 32

    w = 128
    h = 112
    door_h = 112
    door = "DOORSTON"
    track = "METL2"
    special = 32
    tag = 0  -- kind_mult=26

    statue_ent = "blue_statue"
  }


  ----| SWITCHED DOORS |---- 

  Door_SW_1 =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _switch = "sw_metal"
    _long = 192
    _deep = 32

    w = 128
    h = 112
    door = "DMNMSK"
    track = "METL2"
    door_h = 112
    special = 0
  }

  Switch_1 =
  {
    _prefab = "SMALL_SWITCH"
    _where  = "chunk"
    _switch = "sw_metal"

    switch_h = 64
    switch = "SW1OFF"
    side = "METL2"
    base = "METL2"
    x_offset = 0
    y_offset = 32
    special = 103
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

--    step = "STEP3"
  }

  Hall_Basic_I_Lift =
  {
    _prefab = "HALL_BASIC_I_LIFT"
    _shape  = "IL"
    _tags   = 1

    lift = "DOORSTON"
    top  = "FLOOR08"

    lift_h = 128
    lift_delta = -8
    q_trigger = 0

    raise_W1 = 0
    lower_WR = 88
    lower_SR = 62
  }


  ---| TELEPORTERS |---

  Teleporter1 =
  {
    _prefab = "TELEPORT_PAD"
    _where  = "chunk"

    top  = "FLTTELE1"
    side = "SQPEB1"

    glitter_obj = "glitter_red"

    x_offset = 0
    y_offset = 0
    peg = 1

    special = 97
    top_special = 8
    light = 255
  }

}


----------------------------------------------------------------

HERETIC.COMBOS =
{
  ---- INDOOR ------------

  GOLD =
  {
    theme_probs = { CITY=20, EGYPT=20 }
    mat_pri = 6,

    wall  = "SANDSQ2",
    floor = "FLOOR06",
    ceil  = "FLOOR11",

--  void = "SNDBLCKS",
    pillar = "SNDCHNKS",

    scenery = "wall_torch",

    wall_fabs = { wall_pic_GLASS1=30, wall_pic_GLASS2=15, other=10 }
  }

  BLOCK =
  {
    theme_probs = { CITY=20 }
    mat_pri = 7,

    wall  = "GRSTNPB",
    floor = "FLOOR03",
    ceil  = "FLOOR03",

    void = "GRSTNPBW",
    pillar = "WOODWL",

    scenery = "barrel",

  }

  MOSSY =
  {
    theme_probs = { CITY=20, DOME=20 }
    mat_pri = 2,

    wall  = "MOSSRCK1",
    floor = "FLOOR00",
    ceil  = "FLOOR04",

    pillar = "SKULLSB1", -- SPINE1

    scenery = "chandelier",

  }

  WOOD =
  {
    theme_probs = { CITY=20, EGYPT=20 }
    mat_pri = 2,

    wall  = "WOODWL",
    floor = "FLOOR10",
    ceil  = "FLOOR12",

--  void = "CTYSTUC3",

    scenery = "hang_skull_1",

  }

  HUT =
  {
    theme_probs = { CITY=20, DOME=20 }
    mat_pri = 1,
    
    wall  = "CTYSTUC3",
    floor = "FLOOR10",
    ceil  = "FLOOR11",

--  void = "CTYSTUC4",

    scenery = "barrel",

  }

  DISCO1 = 
  {
    theme_probs = { EGYPT=20 }
    mat_pri = 1,
    
    wall  = "SPINE2",
    floor = "FLAT522",
    ceil  = "FLOOR06",
    step  = "SNDBLCKS",

--  void = "CTYSTUC4",

  }
 
  --- Grey-walls, pink/brown floors 
  DISCO2 = 
  {
    theme_probs = { DOME=20 }
    mat_pri = 1,
    
    wall  = "SQPEB1",
    floor = "FLAT522",
    ceil  = "FLOOR06",
    step  = "SPINE2",

--  void = "CTYSTUC4",

  }
  
  PYRAMID =
  {
    theme_probs = { EGYPT=20 }
    mat_pri = 1,
    
    wall  = "SNDPLAIN",
    floor = "FLOOR27",
    ceil  = "FLOOR10",
    step  = "SPINE2",

--  void = "CTYSTUC4",

  }

  PHAROAH =
  {
    theme_probs = { EGYPT=15 }
    mat_pri = 1,
    
    wall  = "TRISTON2",
    floor = "FLAT522",
    ceil  = "FLOOR20",
    step  = "SQPEB2",

--  void = "CTYSTUC4",

  }

  PARLOR =
  {
    theme_probs = { EGYPT=15 }
    mat_pri = 1,
    
    wall  = "SQPEB2",
    floor = "FLOOR06",
    ceil  = "FLOOR06",
    step  = "SQPEB2",

--  void = "CTYSTUC4",

    scenery = "wall_torch",
  }

  SBLOCK =
  {
    theme_probs = { EGYPT=20 }
    mat_pri = 1,
    
    wall  = "SNDBLCKS",
    floor = "FLOOR27",
    ceil  = "FLOOR10",
    step  = "SPINE2",

--  void = "CTYSTUC4",

  }


  CAVE1 = 
  {
    theme_probs = { CAVE=20 }
    mat_pri = 1,
    wall = "LOOSERCK",
    floor = "FLAT516",
    ceil = "FLOOR01",

    scenery = "stal_big_C",
 
  }

  CAVE2 = 
  {
    theme_probs = { CAVE=20 }
    mat_pri = 1,
    wall = "LAVA1",
    floor = "FLAT516",
    ceil = "FLAT506",

    scenery = "stal_small_C",
 
  }

  CAVE3 =  -- Muddy walls, but one of the few outdoor textures
  {
    theme_probs = { CAVE=20, EGYPT=10 }
    mat_pri = 1,
    wall = "BRWNRCKS",
    floor = "FLOOR01",
    ceil = "FLAT516",

    scenery = "stal_small_C",
 
  }

  PURPLE =
  {
    theme_probs = { GARISH=20 }
    mat_pri = 1,

    wall  = "BLUEFRAG",
    floor = "FLOOR07",
    ceil  = "FLOOR07",

--  void = "CTYSTCI4",

  }

  BLUE =
  {
    theme_probs = { GARISH=20 }
    mat_pri = 1,

    wall  = "MOSAIC1",
    floor = "FLAT502",
    ceil  = "FLOOR16",

--  void = "CTYSTCI4",

  }

--- The greens don't look that great in Heretic
  GREEN =
  {
    theme_probs = { UNUSED=20 }
    mat_pri = 1,

    wall  = "GRNBLOK1",
    floor = "FLAT513",
    ceil  = "FLOOR18",

--  void = "CTYSTCI4",

  }

  ICE =
  {
    theme_probs = { GARISH=20 }
    mat_pri = 1,

    wall  = "STNGLS1",
    floor = "FLAT502",
    ceil  = "FLAT517",

--  void = "CTYSTCI4",

  }

  ROOT =
  {
    theme_probs = { CAVE=15 }
    mat_pri = 1,

    wall  = "ROOTWALL",
    floor = "FLAT506",
    ceil  = "FLAT506",

--  void = "CTYSTCI4",

  }

  ---- OUTDOOR ------------

  CAVEO1 = 
  {
    theme_probs = { CAVE=20 }
    mat_pri = 2,
    outdoor = true,
    wall = "LOOSERCK",
    floor = "FLAT516",
    ceil = "FLOOR01",

    scenery = "stal_big_F",
 
  }

  CAVEO2 = 
  {
    theme_probs = { CAVE=20 }
    mat_pri = 2,
    outdoor = true,
    wall = "LAVA1",
    floor = "FLAT516",
    ceil = "FLAT506",

    scenery = "stal_small_F",
 
  }

  CAVEMUD = 
  {
    theme_probs = { CAVE=15 }
    mat_pri = 2,
    outdoor = true,
    wall = "RCKSNMUD",
    floor = "FLAT510",
    ceil = "FLAT510",

    scenery = "stal_small_F",
 
  }


  --- Looks obnoxious outdoors; disabled
  ROOTO =
  {
    theme_probs = { UNUSED=15 }
    mat_pri = 2,
    outdoor = true,

    wall  = "ROOTWALL",
    floor = "FLAT506",
    ceil  = "FLAT506",

--  void = "CTYSTCI4",

  }


  ODISCO1 = 
  {
    theme_probs = { EGYPT=20 }
    mat_pri = 1,
    outdoor = true,
    
    wall  = "SPINE2",
    floor = "FLAT522",
    ceil  = "FLOOR06",
    step  = "SNDBLCKS",

--  void = "CTYSTUC4",

  }

  
  ODISCO2 = 
  {
    theme_probs = { DOME=20 }
    mat_pri = 1,
    outdoor = true,
    
    wall  = "SQPEB1",
    floor = "FLAT522",
    ceil  = "FLOOR06",
    step  = "SPINE2",

--  void = "CTYSTUC4",

  }

  PYRAMIDO =
  {
    theme_probs = { EGYPT=20 }
    mat_pri = 1,
    outdoor = true,
    
    wall  = "SNDPLAIN",
    floor = "FLOOR27",
    ceil  = "FLOOR27",
    step  = "SPINE2",

--  void = "CTYSTUC4",

  }

  PHAROAHO =
  {
    theme_probs = { EGYPT=15 }
    mat_pri = 1,
    outdoor = true,
    
    wall  = "TRISTON2",
    floor = "FLAT521",
    ceil  = "FLAT503",
    step  = "SQPEB2",

--  void = "CTYSTUC4",

  }
  
  WATER =
  {
    theme_probs = { GARISH=20 }
    outdoor = true,
    mat_pri = 1,

    wall  = "WATRWAL1",
    floor = "FLTWAWA1",
    ceil  = "FLTWAWA1",

--  void = "CTYSTCI4",

    liquid_prob = 0,
  }

  PURPLEO =
  {
    theme_probs = { GARISH=20 }
    outdoor = true,
    mat_pri = 1,

    wall  = "REDWALL",
    floor = "FLOOR07",
    ceil  = "FLOOR07",

--  void = "CTYSTCI4",

  }

  GREENO =
  {
    theme_probs = { UNUSED=20 }
    outdoor = true,
    mat_pri = 1,

    wall  = "GRNBLOK1",
    floor = "FLOOR18",
    ceil  = "FLOOR18",

--  void = "CTYSTCI4",

  }

  STONY =
  {
    theme_probs = { CITY=20 }
    outdoor = true,
    mat_pri = 3,

    wall  = "GRSTNPB",
    floor = "FLOOR00",
    ceil  = "FLOOR00",

--  void = "GRSTNPBV",
    scenery = "serpent_torch",
  }

  MUDDY =
  {
    theme_probs = { CITY=20, DOME=20 }
    outdoor = true,
    mat_pri = 3,

    wall  = "CSTLRCK",
    floor = "FLOOR17",
    ceil  = "FLOOR17",

--  void = "SQPEB1",
    pillar = "SPINE1",

    scenery = "fire_brazier",

  }
  
  SANDZ =
  {
    theme_probs = { EGYPT=20 }
    outdoor = true,
    mat_pri = 1,

    wall  = "SNDBLCKS",
    floor = "FLOOR27",
    ceil  = "FLOOR27",

--  void = "CTYSTCI4",

    liquid_prob = 0,
  }

  SANDY =
  {
    theme_probs = { CITY=20, DOME=20 }
    outdoor = true,
    mat_pri = 2,
    
    wall  = "CTYSTUC2",
    floor = "FLOOR27",
    ceil  = "FLOOR27",

--  void = "CTYSTUC3",
    pillar = "SPINE2",

    scenery = "small_pillar",
  }
  
}


----------------------------------------------------------------

HERETIC.EXITS =
{
  exit_pillar =
  {
    h=128, switch_w="SW2OFF",
  }

--[[
  METAL =
  {
    mat_pri = 9,

    wall  = "METL2",
    floor = "FLOOR03",
    ceil  = "FLOOR19",

    switch =
    {
      prefab="SWITCH_NICHE_TINY_DEEP",
      add_mode="wall",
      skin =
      {
        switch_w="SW2OFF", wall="METL2",
--      switch_f="FLOOR28",

        switch_h=32, x_offset=16, y_offset=48,
        kind=11, tag=0,
      }
    }
  }
  BLOODY = -- name hardcoded in planner.lua for secret exit
  {
    secret_exit = true,
    mat_pri = 9,

    wall  = "METL2",
    floor = "FLOOR03",
    ceil  = "FLOOR19",

    switch =
    {
      prefab="SWITCH_NICHE_TINY_DEEP",
      add_mode="wall",
      skin =
      {
        switch_w="SW1OFF", wall="METL2",
--      switch_f="FLOOR28",

        switch_h=32, x_offset=16, y_offset=48,
        kind=51, tag=0,
      }
    }
  }
--]]
}

HERETIC.HALLWAYS =
{
 
  -- Hall with set stone walls 
  RCKHALL = {
        mat_pri = 0,
	theme_probs = { CITY=20, DOME=20 }
    	wall = "GRSTNPB",
	void = "GRSTNPB",
    	step  = "GRSTNPB",
	pillar = "WOODWL",
	
    floor = "FLOOR03",
    ceil  = "FLOOR03",
	
  }

  -- Hall with natural stone walls
  STHALL = {
        mat_pri = 0,
	theme_probs = { CITY=20, CAVE=20 }
    	wall = "LOOSERCK",
	void = "LOOSERCK",
    	step  = "GRSTNPB",
	pillar = "GRSTNPB",
	
    floor = "FLOOR00",
    ceil  = "FLOOR00",
	
  }

  -- Hall with roots on the walls
  RTHALL = {
        mat_pri = 0,
	theme_probs = { CAVE=20 }
    	wall = "ROOTWALL",
	void = "ROOTWALL",
    	step  = "ROOTWALL",
	pillar = "ROOTWALL",
	
    floor = "FLAT506",
    ceil  = "FLAT506",
	
  }

  -- Hall with sandy walls
  SDHALL = {
        mat_pri = 0,
	theme_probs = { EGYPT=20 }
    	wall = "SNDPLAIN",
	void = "SNDPLAIN",
    	step  = "SPINE2",
	pillar = "SPINE2",
	
    floor = "FLOOR27",
    ceil  = "FLOOR10",
	
  }

  -- Hall with wooden walls
  WDHALL = {
        mat_pri = 0,
	theme_probs = { CITY=20, EGYPT=20 }
    	wall = "SQPEB2",
	void = "SQPEB2",
    	step  = "SQPEB2",
	pillar = "SQPEB2",
	
    floor = "FLOOR06",
    ceil  = "FLOOR06",
	
  }

  -- Garish blue watery hall
  WHALL = {
        mat_pri = 0,
	theme_probs = { GARISH=20, DOME=20 }
    	wall = "MOSAIC1",
	void = "MOSAIC1",
    	step  = "WATRWAL1",
	pillar = "WATRWAL1",
	
    floor = "FLTWAWA1",
    ceil  = "FLAT502",
	
  }
}




--- PEDESTALS --------------

HERETIC.PEDESTALS =
{
  PLAYER =
  {
    wall  = "CTYSTCI4", void = "CTYSTCI4",
    floor = "FLOOR11",   ceil = "FLOOR11",
    h = 8,
  }

  QUEST = -- FIXME
  {
    wall  = "CTYSTCI4", void = "CTYSTCI4",
    floor = "FLOOR11",   ceil = "FLOOR11",
    h = 8,
  }

  WEAPON = -- FIXME
  {
    wall  = "CTYSTCI4", void = "CTYSTCI4",
    floor = "FLOOR11",  ceil = "FLOOR11",
    h = 8,
  }
}

---- OVERHANGS ------------

HERETIC.OVERHANGS =
{
  WOOD =
  {
    ceil = "FLOOR10",
    upper = "CTYSTUC3",
    thin = "WOODWL",
  }
}

---- MISC STUFF ------------

HERETIC.SWITCHES =
{
  sw_demon =
  {
    switch =
    {
      prefab = "SWITCH_NICHE_TINY",
      add_mode = "island",
      skin =
      {
        wall="GRSKULL1",
        switch_w="SW1OFF", switch_h=32,
        x_offset=16, y_offset=48, kind=103,
      }
    }

    door =
    {
      w=128, h=128,
      prefab = "DOOR",
      skin =
      {
        door_w="DMNMSK", door_c="FLOOR10",
        track_w="METL2",
        door_h=128,
        door_kind=0, tag=0,
      }
    }
  }

  sw_celtic =
  {
    switch =
    {
      prefab="SWITCH_NICHE_TINY",
      add_mode = "island",
      skin =
      {
        wall="CELTIC",
        switch_w="SW1OFF", switch_h=32,
        x_offset=16, y_offset=48, kind=103,
      }
    }

    door =
    {
      w=128, h=128,
      prefab = "DOOR",
      skin =
      {
        door_w="CELTIC", door_c="FLAT522",
        track_w="METL2",
        door_h=128,
        door_kind=0, tag=0,
      }
    }
  }

  sw_green =
  {
    switch =
    {
      prefab = "SWITCH_NICHE_TINY",
      add_mode = "island",
      skin =
      {
        wall="GRNBLOK1",
        switch_w="SW1OFF", switch_h=32,
        x_offset=16, y_offset=48, kind=103,
      }
    }

    door =
    {
      w=128, h=128,
      prefab = "DOOR",
      skin =
      {
        door_w="GRNBLOK4", door_c="FLOOR18",
        track_w="METL2",
        door_h=128,
        door_kind=0, tag=0,
      }
    }
  }
}


HERETIC.DOORS =
{
  d_demon =
  {
    w=128, h=128, door_h=128,
    door_w="DMNMSK", door_c="FLOOR10",
    step_w="METL2", track="METL2",
    key_ox=20, key_oy=-16,
    special=1, tag=0,
  }

  d_wood =
  {
    w=128, h=128, door_h=128,
    door_w="DOORWOOD", door_c="FLOOR01",
    step_w="METL2", track="METL2",
    key_ox=20, key_oy=-16,
    special=1, tag=0,
  }


--[[
  d_demon = { prefab="DOOR", w=128, h=128,

               skin =
               {
                 door_w="DMNMSK", door_c="FLOOR10",
                 track_w="METL2",
                 door_h=128,

---              lite_w="LITE5", step_w="STEP1",
---              frame_f="FLAT1", frame_c="TLITE6_6",
               }
             }
  
 d_wood   = { wall="DOORWOOD", w=64,  h=128, ceil="FLOOR10" }
  
--  d_stone  = { wall="DOORSTON", w=64,  h=128 }
--]]


  -- LOCKED DOORS --

  k_blue =
  {
    w=128, h=128, door_h=128, 

    door_w="DOORSTON", door_c="FLOOR28",
    track="METL2",
    frame_f="FLOOR04",
    special=32, tag=0,  -- kind_rep=26

    statue = "blue_statue",
  }

  k_green =
  {
    w=128, h=128, door_h=128,

    door_w="DOORSTON", door_c="FLOOR28",
    track="METL2",
    frame_f="FLOOR04",
    special=33, tag=0, -- kind_rep=28,

    statue = "green_statue",
  }

  k_yellow =
  {
    w=128, h=128, door_h=128,

    door_w="DOORSTON", door_c="FLOOR28",
    track="METL2",
    frame_f="FLOOR04",
    special=34, tag=0, -- kind_rep=27,

    statue = "yellow_statue",
  }
}


HERETIC.LIFTS =
{
  slow = { kind=62,  walk=88 }
}

HERETIC.DOOR_PREFABS =  -- NB: OBSOLETE
{
  d_wood =
  {
    w=128, h=128, prefab="DOOR",

    skin =
    {
      door_w="DOORWOOD", door_c="FLOOR10",
      track="METL2", frame_f="FLOOR04",
      step_w="CHAINSD", key_w="CHAINSD",
      door_h=128,
      special=1, tag=0,
    }

  theme_probs = { CITY=20 }
  }
}

HERETIC.WALL_PREFABS =
{
  wall_pic_GLASS1 =
  {
    prefab = "WALL_PIC_SHALLOW",
    min_height = 160,
    skin = { pic_w="STNGLS1", pic_h=128 }
  }

  wall_pic_GLASS2 =
  {
    prefab = "WALL_PIC_SHALLOW",
    min_height = 160,
    skin = { pic_w="STNGLS2", pic_h=128 }
  }
}

HERETIC.MISC_PREFABS =
{
  pedestal_PLAYER =
  {
    prefab = "PEDESTAL",
    skin = { wall="TMBSTON2", floor="FLOOR26", ped_h=8 }
  }

  pedestal_ITEM =
  {
    prefab = "PEDESTAL",
    skin = { wall="SAINT1", floor="FLAT500", ped_h=12 }
  }

  image_1 =
  {
    prefab = "CRATE",
    add_mode = "island",
    skin = { crate_h=64, crate_w="CHAINSD", crate_f="FLOOR27" }
  }

  image_2 =
  {
    prefab = "WALL_PIC_SHALLOW",
    add_mode = "wall",
    min_height = 144,
    skin = { pic_w="GRSKULL2", pic_h=128 }
  }

  exit_DOOR =
  {
    w=64, h=96, prefab = "DOOR_NARROW",

    skin =
    {
      door_w="DOOREXIT",
      door_h=96,
      door_kind=1, tag=0,
    }
  }

  secret_DOOR =
  {
    w=128, h=128, prefab = "DOOR",

    skin =
    {
      track_w="METL2",
      door_h=128, door_kind=31, tag=0
    }
  }
}


HERETIC.IMAGES =
{
  { wall = "GRSKULL2", w=128, h=128, glow=true }
  { wall = "GRSKULL1", w=64,  h=64,  floor="FLOOR27" }
}

HERETIC.LIGHTS =
{
  round = { floor="FLOOR26",  side="ORNGRAY" }
}

HERETIC.WALL_LIGHTS =
{
  redwall = { wall="REDWALL", w=32 }
}

HERETIC.PICS =
{
  skull3 = { wall="GRSKULL3", w=128, h=128 }
  glass1 = { wall="STNGLS1",  w=128, h=128 }
}


---- QUEST STUFF ----------------

HERETIC.THEME_DEFAULTS =
{
  starts = { Start_basic = 50 }

  exits = { Exit_switch = 50 }

  pedestals = { Pedestal_1 = 50 }

  stairs = { Stair_Up1 = 50, Stair_Down1 = 50,
             Lift_Up1 = 2, Lift_Down1 = 2 }

  -- according to Borsuk, locked doors should always appear in the
  -- following order: Yellow ==> Green ==> Blue.
  keys = { k_yellow=9000, k_green=90, k_blue=1 }

  switches = { sw_metal=50 }

  switch_fabs = { Switch_1=50 }

  locked_doors = { Locked_yellow=50, Locked_green=50, Locked_blue=50,
                   Door_SW_1=50 }

  teleporters = { Teleporter1=50 }


  steps = { step1=50 }

  doors = { d_wood=50, d_demon=15 }

  logos = { carve=50, pill=50 }

  hallway_groups = { basic = 50 }


--FIXME TEMP STUFF
  cave_walls = { BRWNRCKS=10, LAVA1=20, LOOSERCK=20,
                 RCKSNMUD=20, ROOTWALL=30,
               }

  landscape_walls = { BRWNRCKS=10, LAVA1=20, LOOSERCK=20,
                      RCKSNMUD=20, ROOTWALL=10,
                    }

  periph_pillar_mat = "WOODWL",
  beam_mat = "WOODWL",
  track_mat = "METL2",
  pedestal_mat = "FLAT500",
}


HERETIC.NAME_THEMES =
{
  -- TODO
}


HERETIC.HALLWAY_GROUPS =
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
}


HERETIC.ROOM_THEMES =
{
  ---- URBAN THEME -----------------

  Urban_house1 =
  {
    walls =
    {
      CTYSTCI2 = 20
      CTYSTCI4 = 40
    }

    floors =
    {
      FLOOR03 = 50
      FLOOR06 = 50
      FLOOR10 = 50
    }

    ceilings =
    {
      FLAT521 = 50
      FLAT523 = 50
    }
  }

  Urban_house2 =
  {
    walls =
    {
      CTYSTUC4 = 50
    }

    floors =
    {
      FLOOR03 = 50
      FLOOR06 = 50
      FLOOR10 = 50
    }

    ceilings =
    {
      FLAT521 = 50
      FLAT523 = 50
    }
  }

  Urban_stone =
  {
    walls =
    {
      GRSTNPB = 50
    }

    floors =
    {
      FLOOR00 = 50
      FLOOR19 = 50
      FLAT522 = 50
      FLAT523 = 50
    }

    ceilings =
    {
      FLAT520 = 50
      FLAT523 = 50
    }
  }

  Urban_wood =
  {
    walls =
    {
      WOODWL = 50
    }

    floors =
    {
      FLAT508 = 20
      FLOOR11 = 20
      FLOOR03 = 50
      FLOOR06 = 50
    }

    ceilings =
    {
      FLOOR10 = 50
      FLOOR11 = 30
      FLOOR01 = 50
    }
  }


  ---- CASTLE THEME -----------------

  Castle_green =
  {
    walls =
    {
      GRNBLOK1 = 50
      MOSSRCK1 = 50
    }

    floors =
    {
      FLOOR19 = 20
      FLOOR27 = 50
      FLAT520 = 50
      FLAT521 = 50
    }

    ceilings =
    {
      FLOOR05 = 50
      FLAT512 = 50
    }
  }

  Castle_gray =
  {
    walls =
    {
      CSTLRCK  = 50
      TRISTON1 = 50
    }

    floors =
    {
      FLAT503 = 50
      FLAT522 = 50
      FLOOR10 = 50
    }

    ceilings =
    {
      FLOOR04 = 50
      FLAT520 = 50
    }
  }

  Castle_orange =
  {
    walls =
    {
      SQPEB2   = 50
      TRISTON2 = 50
    }

    floors =
    {
      FLOOR01 = 50
      FLOOR03 = 50
      FLOOR06 = 20
    }

    ceilings =
    {
      FLAT523 = 50
      FLOOR17 = 50
    }
  }

  Castle_hallway =
  {
    walls =
    {
      GRSTNPB  = 60
      SANDSQ2  = 20
      SNDCHNKS = 20
    }

    floors =
    {
      FLOOR00 = 50
      FLOOR18 = 50
      FLAT521 = 50
      FLAT506 = 50
    }

    ceilings =
    {
      FLAT523 = 50
    }
  }



  ---- OTHER STUFF ------------------

  Cave_generic =
  {
    naturals =
    {
      LOOSERCK=20, LAVA1=20, BRWNRCKS=20
    }
  }


  Outdoors_generic =
  {
    floors =
    {
      FLOOR00=20, FLOOR27=30, FLOOR18=50,
      FLAT522=10, FLAT523=20,
    }

    naturals =
    {
      FLOOR17=50, FLAT509=20, FLAT510=20,
      FLAT513=20, FLAT516=35, 
    }
  }
}


HERETIC.LEVEL_THEMES =
{
  heretic_urban1 =
  {
    prob = 50

    liquids = { water=50, sludge=15, lava=4 }

    buildings = { Urban_house1=30, Urban_house2=30,
                  Urban_wood=30, Urban_stone=50
                }

    hallways = { Castle_hallway=50 }  -- FIXME

    caves = { Cave_generic=50 }

    outdoors = { Outdoors_generic=50 }

    --TODO: more stuff

  }  -- CITY1


  heretic_castle1 =
  {
    prob = 50

    liquids = { lava=50, magma=20, sludge=3 }

    buildings = { Castle_green=50, Castle_gray=50,
                  Castle_orange=50
                }

    hallways = { Castle_hallway=50 }

    caves = { Cave_generic=50 }

    outdoors = { Outdoors_generic=50 }

    -- hallways = { blah }

    --TODO: more stuff
  }
}


------------------------------------------------------------

HERETIC.MONSTERS =
{
  gargoyle =
  {
    level = 1
    prob = 30
    health = 20
    damage = 5
    attack = "melee"
    float = true
  }

  fire_garg =
  {
    level = 3
    prob = 10
    health = 80
    damage = 8
    attack = "missile"
    float = true
  }

  mummy =
  {
    level = 1
    prob = 60
    health = 80
    damage = 8
    attack = "melee"
    give = { {ammo="crystal",count=1} }
  }

  mummy_inv =
  {
    replaces = "mummy"
    replace_prob = 15
    health = 80
    damage = 8
    attack = "melee"
    give = { {ammo="crystal",count=1} }
    invis = true
  }

  sabreclaw =  -- MT_CLINK
  {
    level = 5
    prob = 25
    health = 150
    damage = 12
    attack = "melee"
    give = { {ammo="rune",count=6} }
  }

  knight =
  {
    level = 1
    prob = 70
    health = 200
    damage = 12
    attack = "missile"
    give = { {ammo="arrow",count=1.6} }
  }

  knight_inv =
  {
    replaces = "knight"
    replace_prob = 15
    health = 200
    damage = 14
    attack = "missile"
    give = { {ammo="arrow",count=1.6} }
    invis = true
  }

  leader =
  {
    level = 4
    prob = 70
    health = 100
    damage = 16
    attack = "missile"
    give = { {ammo="crystal",count=1} }
  }

  leader_inv =
  {
    replaces = "leader"
    replace_prob = 15
    health = 100
    damage = 16
    attack = "missile"
    give = { {ammo="crystal",count=1} }
    invis = true
  }

  disciple =  -- MT_WIZARD
  {
    level = 6
    prob = 25
    health = 180
    damage = 20
    attack = "missile"
    give = { {ammo="claw_orb",count=3} }
    float = true
  }

  weredragon =  -- MT_BEAST
  {
    level = 6
    prob = 30
    health = 220
    damage = 25
    attack = "missile"
    give = { {ammo="arrow",count=3} }
  }

  ophidian =  -- MT_SNAKE
  {
    level = 7
    prob = 30
    health = 280
    damage = 25
    attack = "missile"
    give = { {ammo="flame_orb",count=1.6} }
  }


  ---| HERETIC BOSSES |---

  -- FIXME: damage values are crap, need 'attack' type

  Ironlich =  -- MT_HEAD
  {
    health = 700
    damage = 60
    give = { {ammo="claw_orb",count=3} }
    float = true
  }

  Maulotaur =
  {
    health = 3000
    damage = 80
    give  = 
    {
      {ammo="flame_orb",count=3}
      {health=10}  -- occasionally drops an Urn
    }
  }

  D_Sparil =
  {
    health = 2000
    damage = 100
  }

  -- NOTES
  --
  -- Most monsters who drop an item after death only do so 33%
  -- of the time (randomly).  The give amounts are therefore
  -- just an average.  Some of them also (but rarely) drop
  -- artifacts (egg/tome) -- this is not modelled.
}


HERETIC.WEAPONS =
{
  staff =
  {
    rate = 2.5
    damage = 12
    attack = "melee"
  }

  wand =
  {
    pref = 10
    rate = 3.1
    damage = 10
    attack = "hitscan"
    ammo = "crystal"
    per = 1
  }

  gauntlets =
  {
    level = 1
    pref = 10
    add_prob = 5
    rate = 5.2
    damage = 8
    attack = "melee"
  }

  crossbow =
  {
    level = 1
    pref = 90
    add_prob = 10
    start_prob = 70
    rate = 1.3
    damage = 20
    attack = "missile"
    splash = {0,5}
    ammo = "arrow"
    per = 1
    give = { {ammo="arrow",count=10} }
  }

  claw =  -- aka blaster
  {
    level = 1
    pref = 60
    add_prob = 20
    start_prob = 20
    rate = 2.9
    damage = 16
    attack = "missile"
    ammo = "claw_orb"
    per = 1
    give = { {ammo="claw_orb",count=30} }
  }

  hellstaff =  -- aka skullrod
  {
    level = 3
    pref = 50
    add_prob = 20
    start_prob = 5
    rate = 8.7
    damage = 12
    attack = "missile"
    ammo = "rune"
    per = 1
    give = { {ammo="rune",count=50} }
  }

  phoenix =
  {
    level = 4
    pref = 50
    add_prob = 20
    rate = 1.7
    damage = 80
    attack = "missile"
    ammo = "flame_orb"
    per = 1
    give = { {ammo="flame_orb",count=2} }
  }

  firemace =
  {
    level = 6
    pref = 35
    add_prob = 20
    rate = 8.7
    damage = 8
    attack = "missile"
    ammo = "mace_orb"
    per = 1
    give = { {ammo="mace_orb",count=50} }
  }

  -- NOTES:
  --
  -- No information here about weapons when the Tome-Of-Power is
  -- being used (such as different firing rates and ammo usage).
  -- Since that artifact can be used at any time by the player,
  -- OBLIGE cannot properly model it.
  --
  -- The Firemace can be placed in upto 8 different spots, but
  -- only one is spawned (at a spot chosen randomly) when the
  -- level is loaded.
}


HERETIC.PICKUPS =
{
  -- HEALTH --

  h_vial =
  {
    prob = 70
    cluster = { 1,4 }
    give = { {health=10} }
  }

  h_flask =
  {
    prob = 25
    give = { {health=25} }
  }

  h_urn =
  {
    -- could actually give upto 99 health points, but the player
    -- will usually waste a lot of it (since their health is
    -- limited to 100).
    prob = 5
    give = { {health=70} }
  }


  -- ARMOR --

  shield1 =
  {
    prob = 20
    give = { {health=50} }
  }

  shield2 =
  {
    prob = 5
    give = { {health=100} }
  }


  -- AMMO --

  crystal =
  {
    prob = 20
    cluster = { 1,4 }
    give = { {ammo="crystal",count=10} }
  }

  geode =
  {
    prob = 40
    give = { {ammo="crystal",count=50} }
  }

  arrow =
  {
    prob = 20
    cluster = { 1,3 }
    give = { {ammo="arrow",count=5} }
  }

  quiver =
  {
    prob = 40
    give = { {ammo="arrow",count=20} }
  }

  claw_orb1 =
  {
    prob = 20
    cluster = { 1,3 }
    give = { {ammo="claw_orb",count=10} }
  }

  claw_orb2 =
  {
    prob = 40
    give = { {ammo="claw_orb",count=25} }
  }

  runes1 =
  {
    prob = 20
    cluster = { 1,4 }
    give = { {ammo="rune",count=20} }
  }

  runes2 =
  {
    prob = 40
    give = { {ammo="rune",count=100} }
  }

  flame_orb1 =
  {
    prob = 20
    cluster = { 2,5 }
    give = { {ammo="flame_orb",count=1} }
  }

  flame_orb2 =
  {
    prob = 40
    give = { {ammo="flame_orb",count=10} }
  }

  mace_orb1 =
  {
    prob = 20
    cluster = { 1,4 }
    give = { {ammo="mace_orb",count=20} }
  }

  mace_orb2 =
  {
    prob = 40
    give = { {ammo="mace_orb",count=100} }
  }
}


HERETIC.ITEMS =
{
  p1 = { pickup="torch", prob=2.0 }
}


HERETIC.PLAYER_MODEL =
{
  cleric =
  {
    stats = { health=0 }
    weapons = { staff=1, wand=1 }
  }
}


------------------------------------------------------------

HERETIC.EPISODES =
{
  episode1 =
  {
    theme = "CITY"
    boss = "Ironlich"
    sky_light = 0.65
    secret_exits = { "E1M6" }
  }

  episode2 =
  {
    theme = "CITY"
    boss = "Maulotaur"
    sky_light = 0.75
    secret_exits = { "E2M4" }
  }

  episode3 =
  {
    theme = "CITY"
    boss = "D_sparil"
    sky_light = 0.75
    secret_exits = { "E3M4" }
  }

  episode4 =
  {
    theme = "CITY"
    boss = "Ironlich"
    sky_light = 0.50
    secret_exits = { "E4M4" }
  }

  episode5 =
  {
    theme = "CITY"
    boss = "Maulotaur"
    sky_light = 0.65
    secret_exits = { "E5M3" }
  }
}


------------------------------------------------------------

function HERETIC.setup()

end


function HERETIC.get_levels()
  local EP_NUM  = (OB_CONFIG.length == "full"   ? 5 ; 1)
  local MAP_NUM = (OB_CONFIG.length == "single" ? 1 ; 9)

  if OB_CONFIG.length == "few" then MAP_NUM = 4 end

  for ep_index = 1,EP_NUM do
    -- create episode info...
    local EPI =
    {
      levels = {}
    }

    table.insert(GAME.episodes, EPI)

    local ep_info = HERETIC.EPISODES["episode" .. ep_index]
    assert(ep_info)

    for map = 1,MAP_NUM do
      -- create level info...
      local LEV =
      {
        episode  = EPI

        name = string.format("E%dM%d", ep_index, map)

         ep_along = map / MAP_NUM
        mon_along = (map + ep_index - 1) / MAP_NUM
      }

      table.insert( EPI.levels, LEV)
      table.insert(GAME.levels, LEV)
    end -- for map

  end -- for episode
end


function HERETIC.make_cool_gfx()
  local GREEN =
  {
    0, 209, 211, 213, 215, 217, 218
  }

  local BROWN =
  {
    0, 66, 68, 70, 73, 76, 79, 82, 86, 90
  }

  local RED =
  {
    0, 251, 253, 145, 147, 149, 151, 153, 155, 157
  }

  local WHITE =
  {
    0,2,4,6,8,10,12, 14,16,18,20,22,24
  }

  local BLUE =
  {
    0, 185, 187, 189, 191, 194, 197, 199, 202
  }


  local colmaps =
  {
    GREEN, BROWN, RED, BLUE
  }

  rand.shuffle(colmaps)

  gui.set_colormap(1, colmaps[1])
  gui.set_colormap(2, colmaps[2])
  gui.set_colormap(3, colmaps[3])
  gui.set_colormap(4, WHITE)

  local carve = "RELIEF"
  local c_map = 3

  if rand.odds(33) then
    carve = "CARVE"
    c_map = 4
  end

  -- patches : SKULLSB2, CHAINSD
  gui.wad_logo_gfx("WALL41", "p", "PILL",  128,128, 1)
  gui.wad_logo_gfx("WALL42", "p", carve,    64,128, c_map)

  -- flats
  gui.wad_logo_gfx("O_BOLT",  "f", "BOLT",  64,64, 2)
  gui.wad_logo_gfx("O_PILL",  "f", "PILL",  64,64, 1)
  gui.wad_logo_gfx("O_CARVE", "f", carve,   64,64, c_map)
end


function HERETIC.all_done()
  HERETIC.make_cool_gfx()
end



------------------------------------------------------------

OB_GAMES["heretic"] =
{
  label = "Heretic"

  format = "doom"

  tables =
  {
    HERETIC
  }

  hooks =
  {
    setup        = HERETIC.setup
    get_levels   = HERETIC.get_levels
    all_done     = HERETIC.all_done
  }
}

OB_THEMES["heretic_urban"] =
{
  label = "Urban"
  for_games = { heretic=1 }
  name_theme = "URBAN"
  mixed_prob = 50
}

OB_THEMES["heretic_castle"] =
{
  label = "Castle"
  for_games = { heretic=1 }
  name_theme = "GOTHIC"
  mixed_prob = 50
}

