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

  BANNER1  = { t="BANNER1",  f="FLOOR03" }
  BANNER2  = { t="BANNER2",  f="FLOOR03" }
  BANNER3  = { t="BANNER3",  f="FLAT520" }
  BANNER4  = { t="BANNER4",  f="FLAT520" }
  BANNER5  = { t="BANNER5",  f="FLOOR25" }
  BANNER6  = { t="BANNER6",  f="FLOOR25" }
  BANNER7  = { t="BANNER7",  f="FLOOR00" }
  BANNER8  = { t="BANNER8",  f="FLOOR00" }
  BLUEFRAG = { t="BLUEFRAG", f="FLOOR16" }
  BRWNRCKS = { t="BRWNRCKS", f="FLOOR17" }

  CELTIC   = { t="CELTIC",   f="FLOOR06" }
  CHAINMAN = { t="CHAINMAN", f="FLAT520" }
  CSTLMOSS = { t="CSTLMOSS", f="FLOOR03" }
  CSTLRCK  = { t="CSTLRCK",  f="FLOOR03" }
  CTYSTCI1 = { t="CTYSTCI1", f="FLOOR11" }
  CTYSTCI2 = { t="CTYSTCI2", f="FLOOR11" }
  CTYSTCI4 = { t="CTYSTCI4", f="FLOOR11" }
  CTYSTUC1 = { t="CTYSTUC1", f="FLOOR11" }
  CTYSTUC2 = { t="CTYSTUC2", f="FLOOR11" }
  CTYSTUC3 = { t="CTYSTUC3", f="FLOOR11" }
  CTYSTUC4 = { t="CTYSTUC4", f="FLOOR11" }
  CTYSTUC5 = { t="CTYSTUC5", f="FLOOR11" }

  DMNMSK   = { t="DMNMSK",   f="FLAT521" }
  DOOREXIT = { t="DOOREXIT", f="FLAT520" }
  DOORSTON = { t="DOORSTON", f="FLOOR30" }
  DOORWOOD = { t="DOORWOOD", f="FLAT507" }
  DRIPWALL = { t="DRIPWALL", f="FLOOR27" }

  GRNBLOK1 = { t="GRNBLOK1", f="FLOOR19" }
  GRNBLOK2 = { t="GRNBLOK2", f="FLOOR19" }
  GRNBLOK3 = { t="GRNBLOK3", f="FLOOR19" }
  GRNBLOK4 = { t="GRNBLOK4", f="FLOOR19" }
  GRSKULL1 = { t="GRSKULL1", f="FLAT521" }
  GRSKULL2 = { t="GRSKULL2", f="FLAT521" }
  GRSKULL3 = { t="GRSKULL3", f="FLAT521" }
  GRSTNPB  = { t="GRSTNPB",  f="FLAT520" }
  GRSTNPBV = { t="GRSTNPBV", f="FLAT520" }
  GRSTNPBW = { t="GRSTNPBW", f="FLAT520" }
  HORSES1  = { t="HORSES1",  f="FLAT520" }

  LOOSERCK = { t="LOOSERCK", f="FLOOR04" }
  METL1    = { t="METL1",    f="FLOOR29" }
  METL2    = { t="METL2",    f="FLOOR28" }
  MOSAIC1  = { t="MOSAIC1",  f="FLAT502" }
  MOSAIC2  = { t="MOSAIC2",  f="FLAT502" }
  MOSAIC3  = { t="MOSAIC3",  f="FLAT502" }
  MOSAIC4  = { t="MOSAIC4",  f="FLAT502" }
  MOSAIC5  = { t="MOSAIC5",  f="FLAT502" }
  MOSSRCK1 = { t="MOSSRCK1", f="FLOOR05" }

  ORNGRAY  = { t="ORNGRAY",  f="FLAT504" }
  RCKSNMUD = { t="RCKSNMUD", f="FLOOR01" }
  REDWALL  = { t="REDWALL",  f="FLOOR09" }
  ROOTWALL = { t="ROOTWALL", f="FLAT506" }

  SAINT1   = { t="SAINT1",   f="FLAT523" }
  SANDSQ2  = { t="SANDSQ2",  f="FLOOR06" }
  SKULLSB1 = { t="SKULLSB1", f="FLOOR30" }
  SNDBLCKS = { t="SNDBLCKS", f="FLOOR06" }
  SNDCHNKS = { t="SNDCHNKS", f="FLAT522" }
  SNDPLAIN = { t="SNDPLAIN", f="FLOOR25" }
  SPINE1   = { t="SPINE1",   f="FLOOR25" }
  SPINE2   = { t="SPINE2",   f="FLOOR25" }

  SQPEB1   = { t="SQPEB1",   f="FLAT504" }
  SQPEB2   = { t="SQPEB2",   f="FLOOR27" }
  STNGLS1  = { t="STNGLS1",  f="FLOOR30" }
  STNGLS2  = { t="STNGLS2",  f="FLOOR30" }
  STNGLS3  = { t="STNGLS3",  f="FLOOR30" }

  TMBSTON1 = { t="TMBSTON1", f="FLAT521" }
  TMBSTON2 = { t="TMBSTON2", f="FLAT521" }
  TRISTON1 = { t="TRISTON1", f="FLOOR00" }
  TRISTON2 = { t="TRISTON2", f="FLOOR17" }
  WOODWL   = { t="WOODWL",   f="FLOOR10" }

  -- switches --

  SW1OFF   = { t="SW1OFF",   f="FLOOR28" }
  SW1ON    = { t="SW1ON",    f="FLOOR28" }

  -- floors --

  FLAT500  = { f="FLAT500", t="SQPEB1" }
  FLAT502  = { f="FLAT502", t="BLUEFRAG" }
  FLAT503  = { f="FLAT503", t="SQPEB1" }
  FLAT504  = { f="FLAT504", t="SQPEB1" }
  FLAT506  = { f="FLAT506", t="ROOTWALL" }
  FLAT507  = { f="FLAT507", t="DOORWOOD" }
  FLAT508  = { f="FLAT508", t="DOORWOOD" }
  FLAT509  = { f="FLAT509", t="LOOSERCK" }
  FLAT510  = { f="FLAT510", t="BRWNRCKS" }

  FLAT512  = { f="FLAT512", t="GRNBLOK1" }
  FLAT513  = { f="FLAT513", t="GRNBLOK1" }
  FLAT516  = { f="FLAT516", t="LOOSERCK" }
  FLAT517  = { f="FLAT517", t="BLUEFRAG" }
  FLAT520  = { f="FLAT520", t="CSTLRCK" }
  FLAT521  = { f="FLAT521", t="SQPEB1" }
  FLAT522  = { f="FLAT522", t="SNDCHNKS" }
  FLAT523  = { f="FLAT523", t="GRSTNPB" }

  FLOOR00  = { f="FLOOR00", t="TRISTON1" }
  FLOOR01  = { f="FLOOR01", t="LOOSERCK" }
  FLOOR03  = { f="FLOOR03", t="CSTLRCK" }
  FLOOR04  = { f="FLOOR04", t="CSTLRCK" }
  FLOOR05  = { f="FLOOR05", t="MOSSRCK1" }
  FLOOR06  = { f="FLOOR06", t="SANDSQ2" }
  FLOOR07  = { f="FLOOR07", t="MOSAIC1" }
  FLOOR08  = { f="FLOOR08", t="CHAINSD" }
  FLOOR09  = { f="FLOOR09", t="REDWALL" }
  FLOOR10  = { f="FLOOR10", t="WOODWL" }
  FLOOR11  = { f="FLOOR11", t="WOODWL" }
  FLOOR12  = { f="FLOOR12", t="WOODWL" }
  FLOOR16  = { f="FLOOR16", t="BLUEFRAG" }
  FLOOR17  = { f="FLOOR17", t="BRWNRCKS" }
  FLOOR18  = { f="FLOOR18", t="GRNBLOK1" }
  FLOOR19  = { f="FLOOR19", t="GRNBLOK1" }

  FLOOR20  = { f="FLOOR20", t="SQPEB2" }
  FLOOR21  = { f="FLOOR21", t="CHAINSD" }
  FLOOR22  = { f="FLOOR22", t="CHAINSD" }
  FLOOR23  = { f="FLOOR23", t="CHAINSD" }
  FLOOR24  = { f="FLOOR24", t="CHAINSD" }
  FLOOR25  = { f="FLOOR25", t="SPINE2" }
  FLOOR26  = { f="FLOOR26", t="CHAINSD" }
  FLOOR27  = { f="FLOOR27", t="SANDSQ2" }
  FLOOR28  = { f="FLOOR28", t="METL2" }
  FLOOR29  = { f="FLOOR29", t="METL1" }
  FLOOR30  = { f="FLOOR30", t="METL1" }

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
  water  = { mat="FLTFLWW1", light=168, special=0 }
  water2 = { mat="FLTWAWA1", light=168, special=0 }
  sludge = { mat="FLTSLUD1", light=168, special=16, damage=20 }
  lava   = { mat="FLATHUH1", light=192, special=16, damage=20 }
  magma  = { mat="FLTLAVA1", light=184, special=16, damage=20 }
}


----------------------------------------------------------------


HERETIC.SKINS =
{
  ----| STARTS |----

  Start_basic =
  {
    _prefab = "START_SPOT"
    _where  = "middle"

    top = "O_BOLT"
  }

  Start_Closet =
  {
    _prefab = "START_CLOSET"
    _where  = "closet"
    _long   = { 192,384 }
    _deep   = { 192,384 }

    step = "FLAT520"

    door = "DOORSTON"
    track = "METL2"

    special = 31  -- open and stay open
    tag = 0

    item1 = "arrow"
    item2 = "h_vial"
  }



  ----| EXITS |----

  Exit_Pillar =
  {
    _prefab = "EXIT_PILLAR",
    _where  = "middle"

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
    _long   = { 192,384 }
    _deep   = { 192,384 }

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

    use_sign = 0
    exit = "METL2"
    exitside = "METL2"

    special = 11
    tag = 0

    item2 = "h_vial"
  }


  ---| WALLS |---

  Wall_plain =
  {
    _file   = "wall/plain.wad"
    _where  = "edge"
    _fitted = "xyz"

    _bound_z1 = 0
    _bound_z2 = 128
  }


  ---| PICTURES |---

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

  Pic_Pill =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "O_PILL"
    pic_w = 128
    pic_h = 32

    light = 64
  }


  Pic_Banner5 =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 288

    pic   = "BANNER5"
    pic_w = 64
    pic_h = 128

    light = 32
  }

  Pic_Banner7 =
  {
    _copy = "Pic_Banner5"

    pic = { BANNER7=50, BANNER8=50 }
  }

  Pic_Saint =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "SAINT1"
    pic_w = { [64]=50, [128]=50 }
    pic_h = 128

    light = 32
  }

  Pic_Mosaic5 =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "MOSAIC5"
    pic_w = 64
    pic_h = 128

    light = 32
  }

  Pic_GrinSkull =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "GRSKULL3"
    pic_w = 128
    pic_h = 128

    light = 32
  }

  Pic_Eagle =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "GRSTNPBW"
    pic_w = 128
    pic_h = 44

    y_offset = 52

    light = 32
  }


  BigPic_ChainMan =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 288

    pic   = "CHAINMAN"
    pic_w = 256
    pic_h = 128

    light = 32
  }

  BigPic_Horses =
  {
    _copy = "BigPic_ChainMan"

    pic = "HORSES1"
  }

  BigPic_Sky =
  {
    _copy = "BigPic_ChainMan"

    pic = "SKY2"
  }


  ----| WINDOWS |----

  Window1 =
  {
    _file   = "window/window1.wad"
    _where  = "edge"
    _fitted = "xy"
    _long   = 192
    _deep   = 24

    track = "METL2"
  }


  ----| FENCES |----

  Sky_fence =
  {
    _file   = "fence/sky_fence.wad"
    _where  = "chunk"
    _fitted = "xy"
  }

  Sky_corner =
  {
    _file   = "fence/sky_corner.wad"
    _where  = "chunk"
    _fitted = "xy"
  }


  ----| KEY |----

  Pedestal_1 =
  {
    _prefab = "PEDESTAL"
    _where  = "middle"

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
    _deep = 48

    door_w = 128
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
    _deep = 48

    door_w = 128
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
    _deep = 48

    door_w = 128
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
    _deep = 48

    door_w = 128
    door_h = 112

    door = "DMNMSK"
    track = "METL2"
    door_h = 112
    special = 0
  }

  Switch_1 =
  {
    _prefab = "SMALL_SWITCH"
    _where  = "middle"
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

    support = "METL1"
    torch_ent = "serpent_torch"
  }

  Sky_Hall_I_Stair =
  {
    _prefab = "SKY_HALL_I_STAIR"
    _shape  = "IS"
    _need_sky = 1

--??    step = "STEP5"
  }


  Secret_Mini =
  {
    _prefab = "SECRET_MINI"
    _shape  = "I"
    _tags   = 1

    pic   = "STNGLS2"
    inner = "SNDCHNKS"
    metal = "METL2"
  }


  ---| BIG JUNCTIONS |---


  ---| TELEPORTERS |---

  Teleporter1 =
  {
    _prefab = "TELEPORT_PAD"
    _where  = "middle"

    tele = "FLTTELE1"
    side = "SQPEB1"

    effect_ent = "glitter_red"

    x_offset = 0
    y_offset = 0
    peg = 1

    special = 97
    effect = 8
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
  starts = { Start_basic = 20, Start_Closet = 90 }

  exits = { Exit_Pillar = 10, Exit_Closet = 90 }

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

  logos = { Pic_Carve=50, Pic_Pill=15 }

  pictures =
  {
    Pic_Banner5 = 30
    Pic_Banner7 = 30
    Pic_Mosaic5 = 5

    Pic_GrinSkull = 50
    Pic_Saint = 60
    Pic_Eagle = 40
  }

  hallway_groups = { hall_basic = 50 }

  mini_halls = { Hall_Basic_I = 50 }

  sky_halls = { sky_hall = 50 }

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


HERETIC.GROUPS =
{
  hall_basic =
  {
    kind = "hallway"

    parts =
    {
      Hall_Basic_I = 50
      Hall_Basic_C = 50
      Hall_Basic_T = 50
      Hall_Basic_P = 50

      Hall_Basic_I_Stair = 20
      Hall_Basic_I_Lift  = 2
    }
  }

  sky_hall =
  {
    kind = "skyhall"

    parts =
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


HERETIC.PREBUILT_LEVELS =
{
  E1M8 =
  {
    { prob=50, file="heretic_boss/maw1.wad", map="E1M8" }
  }

  E2M8 =
  {
    { prob=50, file="heretic_boss/portal1.wad", map="E2M8" }
  }
}


------------------------------------------------------------

HERETIC.MONSTERS =
{
  gargoyle =
  {
    id = 66
    r = 16
    h = 36
    level = 1
    prob = 30
    health = 20
    damage = 5
    attack = "melee"
    float = true
  }

  fire_garg =
  {
    id = 5
    r = 16
    h = 36
    level = 3
    prob = 10
    health = 80
    damage = 8
    attack = "missile"
    float = true
  }

  mummy =
  {
    id = 68
    r = 22
    h = 64
    level = 1
    prob = 60
    health = 80
    damage = 8
    attack = "melee"
    give = { {ammo="crystal",count=1} }
  }

  mummy_inv =
  {
    id = 69
    r = 22
    h = 64
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
    id = 90
    r = 20
    h = 64
    level = 5
    prob = 25
    health = 150
    damage = 12
    attack = "melee"
    give = { {ammo="rune",count=6} }
  }

  knight =
  {
    id = 64
    r = 24
    h = 80
    level = 1
    prob = 70
    health = 200
    damage = 12
    attack = "missile"
    give = { {ammo="arrow",count=1.6} }
  }

  knight_inv =
  {
    id = 65
    r = 24
    h = 80
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
    id = 45
    r = 22
    h = 64
    level = 4
    prob = 70
    health = 100
    damage = 16
    attack = "missile"
    give = { {ammo="crystal",count=1} }
  }

  leader_inv =
  {
    id = 46
    r = 22
    h = 64
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
    id = 15
    r = 16
    h = 72
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
    id = 70
    r = 34
    h = 80
    level = 6
    prob = 30
    health = 220
    damage = 25
    attack = "missile"
    give = { {ammo="arrow",count=3} }
  }

  ophidian =  -- MT_SNAKE
  {
    id = 92
    r = 22
    h = 72
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
    id = 6
    r = 40
    h = 72 
    health = 700
    damage = 60
    give = { {ammo="claw_orb",count=3} }
    float = true
  }

  Maulotaur =
  {
    id = 9
    r = 28
    h = 104
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
    id = 7
    r = 28
    h = 104
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
    id = 2005
    level = 1
    pref = 10
    add_prob = 5
    rate = 5.2
    damage = 8
    attack = "melee"
  }

  crossbow =
  {
    id = 2001
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
    id = 53
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
    id = 2004
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
    id = 2003
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
    id = 2002
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
    id = 81
    prob = 70
    rank = 1
    cluster = { 1,4 }
    give = { {health=10} }
  }

  h_flask =
  {
    id = 82
    prob = 25
    rank = 2
    give = { {health=25} }
  }

  h_urn =
  {
    id = 32
    prob = 5
    rank = 3
    give = { {health=100} }
  }


  -- ARMOR --

  shield1 =
  {
    id = 85
    prob = 20
    rank = 2
    give = { {health=50} }
  }

  shield2 =
  {
    id = 31
    prob = 5
    rank = 3
    give = { {health=100} }
  }


  -- AMMO --

  crystal =
  {
    id = 10
    prob = 20
    rank = 0
    cluster = { 1,4 }
    give = { {ammo="crystal",count=10} }
  }

  geode =
  {
    id = 12
    prob = 40
    rank = 1
    give = { {ammo="crystal",count=50} }
  }

  arrow =
  {
    id = 18
    prob = 20
    rank = 0
    cluster = { 1,3 }
    give = { {ammo="arrow",count=5} }
  }

  quiver =
  {
    id = 19
    prob = 40
    rank = 1
    give = { {ammo="arrow",count=20} }
  }

  claw_orb1 =
  {
    id = 54
    prob = 20
    rank = 0
    cluster = { 1,3 }
    give = { {ammo="claw_orb",count=10} }
  }

  claw_orb2 =
  {
    id = 55
    prob = 40
    rank = 1
    give = { {ammo="claw_orb",count=25} }
  }

  runes1 =
  {
    id = 20
    prob = 20
    rank = 1
    cluster = { 1,4 }
    give = { {ammo="rune",count=20} }
  }

  runes2 =
  {
    id = 21
    prob = 40
    rank = 2
    give = { {ammo="rune",count=100} }
  }

  flame_orb1 =
  {
    id = 22
    prob = 20
    rank = 0
    cluster = { 2,5 }
    give = { {ammo="flame_orb",count=1} }
  }

  flame_orb2 =
  {
    id = 23
    prob = 40
    rank = 1
    give = { {ammo="flame_orb",count=10} }
  }

  mace_orb1 =
  {
    id = 13
    prob = 20
    rank = 1
    cluster = { 1,4 }
    give = { {ammo="mace_orb",count=20} }
  }

  mace_orb2 =
  {
    id = 16
    prob = 40
    rank = 2
    give = { {ammo="mace_orb",count=100} }
  }
}


HERETIC.ITEMS =  -- Note: UNUSED
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

HERETIC.SECRET_EXITS =
{
  E1M6 = true
  E2M4 = true
  E3M4 = true
  E4M4 = true
  E5M3 = true
}

HERETIC.EPISODES =
{
  episode1 =
  {
    theme = "CITY"
    boss = "Ironlich"
    sky_light = 0.65
  }

  episode2 =
  {
    theme = "CITY"
    boss = "Maulotaur"
    sky_light = 0.75
  }

  episode3 =
  {
    theme = "CITY"
    boss = "D_sparil"
    sky_light = 0.75
  }

  episode4 =
  {
    theme = "CITY"
    boss = "Ironlich"
    sky_light = 0.50
  }

  episode5 =
  {
    theme = "CITY"
    boss = "Maulotaur"
    sky_light = 0.65
  }
}


------------------------------------------------------------

function HERETIC.setup()

end


function HERETIC.get_levels()
  local EP_NUM  = (OB_CONFIG.length == "game"   ? 5 ; 1)
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

      LEV.secret_exit = GAME.SECRET_EXITS[LEV.name]

      -- prebuilt levels
      LEV.prebuilt = GAME.PREBUILT_LEVELS[LEV.name]

      if LEV.prebuilt then
        LEV.name_theme = LEV.prebuilt.name_theme or "BOSS"
      end

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
  name_theme = "URBAN"
  mixed_prob = 50
}

OB_THEMES["heretic_castle"] =
{
  label = "Castle"
  name_theme = "GOTHIC"
  mixed_prob = 50
}

