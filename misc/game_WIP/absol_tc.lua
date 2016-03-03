----------------------------------------------------------------
-- GAME DEF : ABSOLUTION (a.k.a. Doom64 TC)
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2012 Andrew Apted
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

ABSOLUTION = { }

ABSOLUTION.ENTITIES =
{
  --- player stuff ---
  player1 = { id=1, r=18, h=56 }
  player2 = { id=2, r=18, h=56 }
  player3 = { id=3, r=18, h=56 }
  player4 = { id=4, r=18, h=56 }

  dm_player     = { id=11 }
  teleport_spot = { id=14 }
  voodoo_doll   = { id=88 }

  --- keys ---
  kc_red     = { id=13 }
  kc_yellow  = { id=6 }
  kc_blue    = { id=5 }

  ks_red     = { id=38 }
  ks_yellow  = { id=39 }
  ks_blue    = { id=40 }

  --- powerups ---
  backpack = { id=8 }
  mega     = { id=83 }
  invul    = { id=2022 }
  invis    = { id=2024 }
  suit     = { id=2025 }
  map      = { id=2026 }
  goggles  = { id=2045 }

  laser_key1 = { id=4000 }
  laser_key2 = { id=4001 }
  laser_key3 = { id=4002 }

  --- scenery ---

  --- miscellaneous ---

  --- ambient sounds ---
}


ABSOLUTION.PARAMETERS =
{
  rails = true
  infighting  =  true
  light_brushes = true

  jump_height = 24

  max_name_length = 28

  skip_monsters = { 10,30 }

  time_factor   = 1.0
  damage_factor = 1.0
  ammo_factor   = 0.8
  health_factor = 0.7
  monster_factor = 0.7
}


----------------------------------------------------------------

ABSOLUTION.MATERIALS =
{
  -- special materials --

  _ERROR = { t="TILEA796", f="FTILEA79" }
  _SKY   = { t="TILEA796", f="F_SKY1"  }

  -- general purpose --

  METAL  = { t="TILEA796", f="FTILEA79" }
  CLANG  = { t="TILE6885", f="FTILE688" }
  RUST   = { t="TILE6860", f="FTILE686" }
  COPPER = { t="TILE391D", f="FTILE391" }


  -- doors --

  TRACK  = { t="TILE7CFA", f="CUSTOMCD" }
  TRACK2 = { t="TILED839", f="CUSTOMCD" }

  DOOR1 = { t="TILED4A9", f="FTILEA79" }
  DOOR2 = { t="TILE55F3", f="FTILEA79" }

  SPLIT_DOOR1 = { t="TILE0CAC", f="FTILEA79" }

  KEY_RED    = { t="TILE7448", f="FTILEA79" }
  KEY_YELLOW = { t="TILE6D7A", f="FTILEA79" }
  KEY_BLUE   = { t="TILE31A4", f="FTILEA79" }

  REMOTE_DOOR = { t="TILE4507", f="FTILEA79" }

  EXIT_SIGN = { t="TILEC6E3", f="FTILEC1B" }


  -- switches --

  SW1EXIT = { t="SW1EXIT", f="FTILE06A" }


  -- floors --

  FLOOR_1  = { f="SPECIAL5", t="TILE1436" }
  FLOOR_2  = { f="FTILEEBD", t="TILEEBDC" }
  FLOOR_3  = { f="FTILEC79", t="TILEA796" }
  FLOOR_4  = { f="FTILE2CF", t="TILE2CFF" }

  HEXFLOOR = { f="FTILED88", t="TILED88E" }
  GRNFLOOR = { f="SPECIALK", t="TILEC5BC" }

  FLOOR_X1 = { f="FTILE7C1", t="TILE7C1E" }

  GREEN_HEX = { f="SPECIALI", t="TILEC5BC" }

  DARK_X1 = { f="FTILEB38", t="TILEB38C" }


  CEIL_1 = { f="FTILEFA4", t="TILEFA49" }
  CEIL_2 = { f="FTILEE57", t="TILEE574" }
  CEIL_3 = { f="FTILED5F", t="TILED5F0" }

  PEDESTAL = { f="CUSTOMN", t="TILE1A3E" }


  -- tech --

  WALL_1 = { t="TILEADAC", f="FTILEA79" }
  WALL_2 = { t="TILED0C9", f="CUSTOM51" }
  WALL_3 = { t="TILESCT1", f="FTILEB45" }
  WALL_4 = { t="TILE9FC9", f="FTILE9FC" }
  WALL_5 = { t="TILE7E3B", f="CUSTOMB" }
  WALL_6 = { t="TILE2292", f="CUSTOM2" }

  HALLWAY_1 = { t="TILE83B7", f="CUSTOM60" }
  HALLWAY_2 = { t="TILEAA3B", f="FTILEA79" }
  HALLWAY_3 = { t="TILE3479", f="CUSTOM55" }
  HALLWAY_4 = { t="TILE7B5E", f="CUSTOM55" }
  HALLWAY_5 = { t="TILE572B", f="FTILEADA" }
  HALLWAY_6 = { t="TILEEE57", f="FTILEEE5" }

  COMPUTER1 = { t="BFALL1",   f="FTILEA79" }
  COMPUTER2 = { t="FIREMAG1", f="FTILEA79" }
  COMPUTER3 = { t="TILEFB85", f="FTILEA79" }
  COMPUTER4 = { t="TILECF11", f="FTILEA79" }

  LIGHT     = { t="TILE4BB3", f="FTILE4BB" }
  RED_LIGHT = { t="TILE7424", f="FTILEA79" }
  GRN_LIGHT = { t="TILE10D0", f="FTILEA79" }

  PLAT_SIDE = { t="TILEE747", f="FTILE1D2" }


  -- urban --

  BRICK1 = { t="TILE0365", f="FTILE0365" }
  BRICK2 = { t="TILE7D22", f="NEW17" }

  BRICK_MOSS = { t="TILE7F58", f="FTILE7F5" }

  FLAT1 = { t="TILEEC99", f="FTILEF60" }

  STONES   = { t="TILE4269", f="X" }
  STONES_R = { t="TILE6D76", f="X" }
  BR_STONE = { t="TILE72B6", f="X" }

  STONES2  = { t="TILE8D65", f="X" }

  BLOCKS   = { t="TILE747D", f="X" }

  WOOD  = { t="TILE1BB5", f="CUSTOM29" }
  WOOD2 = { t="TILEE56B", f="CUSTOMGK" }


  -- naturals --

  GRASS1 = { t="TILED5FC", f="CUSTOMBD" }
  GRASS2 = { t="TILED5FB", f="CUSTOMBE" }

  DARK_ROCK  = { t="TILE0538", f="CUSTOM10" }
  DARK_ROCK2 = { t="TILECB62", f="FTILECB6" }

  LITE_ROCK  = { t="TILE1CB1", f="FTILE1CB" }
  LITE_ROCK2 = { t="TILE9344", f="FTILE934" }

  BROWN_ROCK = { t="TILE1CE0", f="FTILE1CE" }
  GRAY_ROCK  = { t="TILED628", f="CUSTOMAU" }

  DIRT      = { t="TILE4E99", f="FTILE4E9" }
  GRAY_DIRT = { t="TILEA301", f="FTILEA30" }


  -- liquids / animated --

  L_WATER  = { f="FTILE080", t="TILED7C9", sane=1 }
  L_NUKAGE = { f="FTILE2CA", t="TILE0830", sane=1 }
  L_MAGMA  = { f="FTILE0A5", t="TILEB361", sane=1 }
  L_LAVA   = { f="FTILE5A0", t="TILE5A0F", sane=1 }
  L_LAVA2  = { f="FTILE33A", t="TILE33A7", sane=1 }

  PORTAL_X = { f="XPORTAL1", t="TILEAA3B", sane=1 }
  PORTAL_Y = { f="YPORTAL1", t="TILEAA3B", sane=1 }
  PORTAL_Z = { f="ZPORTAL1", t="TILEAA3B", sane=1 }


  -- rails --


  -- other --

  O_PILL   = { t="TILEEB33",  f="FTILEA79",  sane=1 }
  O_CARVE  = { t="TILE0000",  f="FTILEA79",  sane=1 }
  O_BOLT   = { t="TILE0009",  f="FTILEA79",  sane=1 }
}


ABSOLUTION.LIQUIDS =
{
  water  = { mat="L_WATER",  special=0 }
  nukage = { mat="L_NUKAGE", special=16, damage=20 }
--  magma  = { mat="L_MAGMA",  special=16, damage=20 }
  lava   = { mat="L_LAVA",   special=16, damage=20 }
  lava2  = { mat="L_LAVA2",  special=16, damage=20 }
}


----------------------------------------------------------------

ABSOLUTION.SKINS =
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

    step = "FLAT1"

    door = "DOOR2"
    track = "TRACK2"

    special = 31  -- open and stay open
    tag = 0

    item1 = "bullet_box"
    item2 = "stimpack"
  }


  ----| EXITS |----

  Exit_Pillar =
  {
    _prefab = "EXIT_PILLAR",
    _where  = "middle"

    switch = "SW1EXIT"

    special = 11
    tag = 0

    use_sign = 1
    exit = "EXIT_SIGN"
    exitside = "BRICK1"
  }

  Exit_Closet =
  {
    _prefab = "EXIT_CLOSET"
    _where  = "closet"
    _long   = { 192,384 }
    _deep   = { 192,384 }

    door  = "DOOREXIT"
    door_h = 96
    track = "TRACK"

    inner  = "METL2"
    ceil   = "FLOOR19"
    floor2 = "FLOOR19"

    switch  = "SW2OFF"
    sw_side = "METAL"
    sw_oy   = 32

    use_sign = 0

    special = 11
    tag = 0

    item1 = "stimpack"
  }


  ----| KEY |----

  Pedestal_1 =
  {
    _prefab = "PEDESTAL"
    _where  = "middle"

    top = "PEDESTAL"

    light  = 96
    effect = 8
    fx_delta = -32
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

    light = 32
    effect = 1  -- this is mainly to get white light
    fx_delta = -8
  }

  Pic_Bolt =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "O_BOLT"
    pic_w = 64
    pic_h = 64

    light = 32
    effect = 1  -- this is mainly to get white light
    fx_delta = -8
  }

  Pic_Pill =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "O_PILL"
    pic_w = 128
    pic_h = 32

    light = 32
    effect = 1  -- this is mainly to get white light
    fx_delta = -8
  }


  Pic_Computer1 =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "COMPUTER1"
    pic_w = 128
    pic_h = 64

    y_offset = { [64]=80, [0]=20 }

    light = 32
  }

  Pic_Computer2 =
  {
    _copy = "Pic_Computer1"

    pic = "COMPUTER2"

    x_offset = { [0]=50, [64]=50 }
  }

  Pic_RedLight =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "RED_LIGHT"
    pic_w = 32
    pic_h = 128

    light = 32
    effect = 10004
  }

  Pic_GreenLight =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "GRN_LIGHT"
    pic_w = 32
    pic_h = 96

    light = 32
    effect = 10005
  }

  Pic_PurpleLight =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "LIGHT"
    pic_w = 64
    pic_h = 64

    light = 32
    effect = 9995
  }

  Pic_BlueLight =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "LIGHT"
    pic_w = 32
    pic_h = 128

    light = 32
    effect = 10009
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
    _prefab = "DOOR"
    _where  = "edge"
    _key    = "kc_yellow"
    _long = 192
    _deep = 48

    door_w = 128
    door_h = 128

    door = "DOOR1"
    key = "KEY_YELLOW"
    track = "TRACK"
    special = 34
    tag = 0
    color = 9997
  }

  Locked_red =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _key    = "kc_red"
    _long = 192
    _deep = 48

    door_w = 128
    door_h = 128

    door = "DOOR1"
    key = "KEY_RED"
    track = "TRACK"
    special = 33
    tag = 0
    color = 9998
  }

  Locked_blue =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _key    = "kc_blue"
    _long = 192
    _deep = 48

    door_w = 128
    door_h = 128

    door = "DOOR1"
    key = "KEY_BLUE"
    track = "TRACK"
    special = 32
    tag = 0
    color = 9999
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
    door = "REMOTE_DOOR"
    track = "TRACK"
    door_h = 112
    special = 0
  }

  Switch_1 =
  {
    _prefab = "SMALL_SWITCH"
    _where  = "middle"
    _switch = "sw_metal"

    switch_h = 64
    switch = "SW1EXIT"
    side = "METAL"
    base = "CLANG"

    x_offset = 192
    y_offset = 64
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

    lift = "PLAT_SIDE"
    top  = "PLAT_SIDE"

    lift_h = 128
    lift_delta = -8
    q_trigger = 0

    raise_W1 = 0
    lower_WR = 88
    lower_SR = 62
  }



  ---| BIG JUNCTIONS |---


  ---| TELEPORTERS |---

  Teleporter1 =
  {
    _prefab = "TELEPORT_PAD"
    _where  = "middle"

    tele = "PORTAL_Z"

    x_offset = 0
    y_offset = 0
    peg = 1

    special = 97
    effect = 8
    light = 255
  }

}


----------------------------------------------------------------


ABSOLUTION.THEME_DEFAULTS =
{
  starts = { Start_basic = 10, Start_Closet = 90 }

  exits = { Exit_Pillar = 50 }

  pedestals = { Pedestal_1 = 50 }

  stairs = { Stair_Up1 = 50, Stair_Down1 = 50,
             Lift_Up1 = 2, Lift_Down1 = 2 }

  keys = { kc_red=50, kc_yellow=50, kc_blue=50 }

  switches = { sw_metal=50 }

  switch_fabs = { Switch_1=50 }

  locked_doors = { Locked_yellow=50, Locked_red=50, Locked_blue=50,
                   Door_SW_1=50 }

  teleporters = { Teleporter1=50 }

  logos = { Pic_Carve = 20, Pic_Pill = 60, Pic_Bolt = 5 }

  pictures = { Pic_Computer1 = 60, Pic_Computer2 = 60,
               Pic_RedLight = 30, Pic_BlueLight = 30,
               Pic_GreenLight = 30, Pic_PurpleLight = 30 }

  hallway_groups = { basic = 50 }

  mini_halls = { Hall_Basic_I = 50 }


  steps = { step1=50 }

  doors = { d_wood=50, d_demon=15 }

}


ABSOLUTION.NAME_THEMES =
{
  -- TODO
}


ABSOLUTION.HALLWAY_GROUPS =
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


ABSOLUTION.ROOM_THEMES =
{
  ---- TECH THEME -----------------

  Tech_room =
  {
    walls =
    {
      WALL_1 = 50
      WALL_2 = 50
      WALL_3 = 50
      WALL_4 = 20
      WALL_5 = 20
      WALL_6 = 80
    }

    floors =
    {
      HEXFLOOR = 50
      FLOOR_2 = 10
      FLOOR_3 = 50
      FLOOR_4 = 50
      WALL_6 = 20
    }

    ceilings =
    {
      CEIL_2 = 50
      CEIL_3 = 20
      FLOOR_1 = 30
      GREEN_HEX = 20
    }
  }


  Tech_hallway =
  {
    walls =
    {
      HALLWAY_1 = 50
      HALLWAY_2 = 50
      HALLWAY_3 = 50
      HALLWAY_4 = 50
      HALLWAY_5 = 50
      HALLWAY_6 = 50
    }

    floors =
    {
      FLOOR_X1 = 50
      COPPER   = 50
      FLOOR_2  = 30
      CLANG    = 15
      GRNFLOOR = 10
    }

    ceilings =
    {
      CEIL_1 = 20
      COPPER = 40
      DARK_X1 = 20
      GREEN_HEX = 10
    }
  }


  Outdoor_junk =
  {
    floors =
    {
      GRASS2=50
      WOOD=50
      DARK_ROCK2=50
      LITE_ROCK =20
    }

    naturals =
    {
      DARK_ROCK2=50
      LITE_ROCK2=20
      WOOD=40
      L_MAGMA=50
    }
  }


  ---- OTHER STUFF ------------------

}


ABSOLUTION.LEVEL_THEMES =
{
  absolution_tech1 =
  {
    prob = 50

    liquids = { nukage=60, water=20, lava=10 }

    buildings = { Tech_room=50 }
    hallways  = { Tech_hallway=50 }

    caves    = { Outdoor_junk=50 }
    outdoors = { Outdoor_junk=50 }

    --TODO: more stuff

  }

}


------------------------------------------------------------


ABSOLUTION.MONSTERS =
{
  -- TODO: verify the 'damage' fields (check source code)

  zombie =
  {
    id = 3004
    r = 31
    h = 72
    level = 1
    prob = 40
    health = 20
    damage = 4
    attack = "hitscan"
    give = { {ammo="bullet",count=5} }
    density = 1.5
    infights = true
  }

  shooter =
  {
    id = 9
    r = 31
    h = 72
    level = 2
    prob = 50
    health = 30
    damage = 10
    attack = "hitscan"
    give = { {weapon="shotty"}, {ammo="shell",count=4} }
    species = "zombie"
    infights = true
  }

  imp =
  {
    id = 3001
    r = 32
    h = 72
    level = 1
    prob = 60
    health = 60
    damage = 20
    attack = "missile"
  }

  nm_imp =
  {
    id = 400
    r = 32
    h = 72
    level = 2
    prob = 10
    health = 60
    damage = 20
    attack = "missile"
    density = 0.5
    invis = true
    species = "imp"
  }

  skull =
  {
    id = 3006
    r = 16
    h = 56
    level = 3
    prob = 16
    health = 50
    damage = 7
    attack = "melee"
    density = 0.5
    float = true
    weap_prefs = { launch=0.2 }
    infights = true
  }

  demon =
  {
    id = 3002
    r = 32
    h = 56
    level = 1
    prob = 35
    health = 150
    damage = 25
    attack = "melee"
    weap_prefs = { launch=0.5 }
  }

  nm_demon =
  {
    id = 72
    r = 32
    h = 56
    level = 2
    prob = 10
    health = 500
    damage = 25
    attack = "melee"
    density = 0.5
    invis = true
    weap_prefs = { launch=0.2 }
    species = "demon"
  }

  caco =
  {
    id = 3005
    r = 39
    h = 88
    level = 3
    prob = 40
    health = 400
    damage = 35
    attack = "missile"
    density = 0.5
    float = true
  }

  nm_caco =
  {
    id = 66
    r = 39
    h = 88
    level = 4
    prob = 10
    health = 700
    damage = 35
    attack = "missile"
    density = 0.5
    float = true
    invis = true
    weap_prefs = { launch=0.2 }
    species = "caco"
  }

  knight =
  {
    id = 69
    r = 32
    h = 80
    level = 5
    prob = 60
    skip_prob = 90
    crazy_prob = 40
    health = 500
    damage = 45
    attack = "missile"
    density = 0.7
    species = "baron"
  }

  baron =
  {
    id = 3003
    r = 32
    h = 80
    level = 7
    prob = 20
    health = 1000
    damage = 45
    attack = "missile"
    density = 0.5
    weap_prefs = { bfg=3.0 }
  }

  mancubus =
  {
    id = 67
    r = 64
    h = 80
    level = 6
    prob = 37
    health = 600
    damage = 70
    attack = "missile"
    density = 0.6
  }

  arach =
  {
    id = 68
    r = 64
    h = 64
    level = 6
    prob = 25
    health = 500
    damage = 70
    attack = "missile"
    density = 0.5
  }

  pain =
  {
    id = 71
    r = 31
    h = 56
    level = 6
    prob = 8
    crazy_prob = 15
    skip_prob = 180
    health = 600  -- 400 + skulls
    damage = 20
    attack = "missile"
    density = 0.2
    never_promote = true
    float = true
    weap_prefs = { launch=0.2 }
  }


  -- BOSSES --

  -- TODO: CyberDemon  = { id=16,   kind="monster", r=40,h=80 }
  -- TODO: MotherDemon = { id=5000, kind="monster", r=20,h=80 }
}


ABSOLUTION.WEAPONS =
{
  -- TODO: verify all this stuff in the deds / source code
  --       [ESPECIALLY the laser weapon]

  fist =
  {
    attack = "melee"
    rate = 1.5
    damage = 10
  }

  saw =
  {
    id = 2005
    level = 1
    pref = 3
    add_prob = 2
    attack = "melee"
    rate = 8.7
    damage = 10
  }

  berserk =
  {
    id = 2023
    level = 5
    pref = 10
    add_prob = 5
    attack = "melee"
    rate = 1.5
    damage = 90
    give = { {health=70} }
  }

  pistol =
  {
    pref = 5
    attack = "hitscan"
    rate = 1.8
    damage = 10
    ammo = "bullet"
    per = 1
  }

  chain =
  {
    id = 2002
    level = 1
    pref = 70
    add_prob = 35
    attack = "hitscan"
    rate = 8.5
    damage = 10
    ammo = "bullet"
    per = 1
    give = { {ammo="bullet",count=20} }
  }

  shotty =
  {
    id = 2001
    level = 1
    pref = 70
    add_prob = 10
    start_prob = 60
    attack = "hitscan"
    rate = 0.9
    damage = 70
    splash = { 0,10 }
    ammo = "shell"
    per = 1
    give = { {ammo="shell",count=8} }
  }

  super =
  {
    id = 82
    level = 4
    pref = 50
    add_prob = 20
    start_prob = 60
    attack = "hitscan"
    rate = 0.6
    damage = 170
    splash = { 0,30 }
    ammo = "shell"
    per = 2
    give = { {ammo="shell",count=8} }
  }

  launch =
  {
    id = 2003
    level = 3
    pref = 50
    add_prob = 25
    attack = "missile"
    rate = 1.7
    damage = 80
    splash = { 50,20,5 }
    ammo = "rocket"
    per = 1
    give = { {ammo="rocket",count=2} }
  }

  plasma =
  {
    id = 2004
    level = 5
    pref = 30
    add_prob = 13
    attack = "missile"
    rate = 11
    damage = 20
    ammo = "cell"
    per = 1
    give = { {ammo="cell",count=40} }
  }

  bfg =
  {
    id = 2006
    level = 7
    pref = 15
    add_prob = 20
    attack = "missile"
    rate = 0.65  -- tweaked value, normally 0.8
    damage = 300
    splash = {70,70,70,70, 70,70,70,70, 70,70,70,70}
    ammo = "cell"
    per = 40
    give = { {ammo="cell",count=40} }
  }

  laser =
  {
    id = 2009
    level = 9
    pref = 15
    add_prob = 20
    attack = "missile"
    rate = 0.65
    damage = 300
    splash = {70,70,70,70, 70,70,70,70, 70,70,70,70}
    ammo = "cell"
    per = 40
    give = { {ammo="cell",count=40} }
  }
}


ABSOLUTION.PICKUPS =
{
  -- HEALTH --

  potion =
  {
    id = 2014
    prob = 20
    cluster = { 4,7 }
    give = { {health=1} }
  }

  stimpack =
  {
    id = 2011
    prob = 60
    cluster = { 2,5 }
    give = { {health=10} }
  }

  medikit =
  {
    id = 2012
    prob = 100
    give = { {health=25} }
  }

  soul =
  {
    id = 2013
    prob = 3
    big_item = true
    start_prob = 5
    give = { {health=150} }
  }

  -- ARMOR --

  helmet =
  {
    id = 2015
    prob = 10
    armor = true
    cluster = { 4,7 }
    give = { {health=1} }
  }

  green_armor =
  {
    id = 2018
    prob = 5
    armor = true
    big_item = true
    start_prob = 80
    give = { {health=30} }
  }

  blue_armor =
  {
    id = 2019
    prob = 2
    armor = true
    big_item = true
    start_prob = 30
    give = { {health=80} }
  }

  -- AMMO --

  bullets =
  {
    id = 2007
    prob = 10
    cluster = { 2,5 }
    give = { {ammo="bullet",count=10} }
  }

  bullet_box =
  {
    id = 2048
    prob = 40
    give = { {ammo="bullet",count=50} }
  }

  shells =
  {
    id = 2008
    prob = 20
    cluster = { 2,5 }
    give = { {ammo="shell",count=4} }
  }

  shell_box =
  {
    id = 2049
    prob = 40
    give = { {ammo="shell",count=20} }
  }

  rocket =
  {
    id = 2010
    prob = 10
    cluster = { 4,7 }
    give = { {ammo="rocket",count=1} }
  }

  rocket_box =
  {
    id = 2046
    prob = 40
    give = { {ammo="rocket",count=5} }
  }

  cells =
  {
    id = 2047
    prob = 20
    cluster = { 2,5 }
    give = { {ammo="cell",count=20} }
  }

  cell_pack =
  {
    id = 17
    prob = 40
    give = { {ammo="cell",count=100} }
  }
}


ABSOLUTION.ITEMS =
{
}


ABSOLUTION.PLAYER_MODEL =
{
  doomguy =
  {
    stats = { health=0 }
    weapons = { pistol=1, fist=1 }
  }
}


------------------------------------------------------------


function ABSOLUTION.get_levels()
  local MAP_NUM = 10

  if OB_CONFIG.length == "single" then MAP_NUM = 1  end
  if OB_CONFIG.length == "few"    then MAP_NUM = 4  end
  if OB_CONFIG.length == "full"   then MAP_NUM = 32 end

  local EP_NUM = 1

  if MAP_NUM > 10 then EP_NUM = 2 end
  if MAP_NUM > 30 then EP_NUM = 3 end

  -- create episode info...

  for ep_index = 1,EP_NUM do
    local EPI =
    {
      levels = {}
    }

    table.insert(GAME.episodes, EPI)
  end

  -- create level info...

  for map = 1,MAP_NUM do
    -- determine episode from map number
    local ep_index
    local ep_along

    if map > 30 then
      ep_index = 2 ; ep_along = 0.35
    elseif map > 20 then
      ep_index = 3 ; ep_along = (map - 20) / 10
    elseif map > 10 then
      ep_index = 2 ; ep_along = (map - 10) / 10
    else
      ep_index = 1 ; ep_along = map / 11
    end

    if OB_CONFIG.length == "single" then
      ep_along = rand.pick{ 0.2, 0.3, 0.4, 0.6, 0.8 }
    elseif OB_CONFIG.length == "few" then
      ep_along = map / MAP_NUM
    end

    local EPI = GAME.episodes[ep_index]
    assert(EPI)

    local LEV =
    {
      episode = EPI

      name  = string.format("MAP%02d", map)
      patch = string.format("CWILV%02d", map-1)

      ep_along = ep_along
    }

    table.insert( EPI.levels, LEV)
    table.insert(GAME.levels, LEV)

    if map == 31 or map == 32 then
      -- secret levels are easy
      LEV.mon_along = 0.35
    elseif OB_CONFIG.length == "single" then
      LEV.mon_along = ep_along
    else
      -- difficulty ramps up over whole wad
      LEV.mon_along = map * 1.2 / math.min(MAP_NUM, 20)
    end
  end
end


function ABSOLUTION.make_cool_gfx()
  local WHITE =
  {
    0, 3, 6, 9, 12, 15, 18, 20, 22
  }

  local GREEN =
  {
    0, 127, 125, 123, 121, 119, 117, 113    
  }

  local RED =
  {
    0, 223, 221, 219, 217, 215, 213, 211, 209
  }

  local BLUE =
  {
    0, 63, 61, 59, 57, 55, 53, 51
  }

  local BROWN =
  {
    0, 143, 141, 139, 137, 135, 133, 131
  }

  local BRONZE =
  {
    0, 159, 157, 155, 153, 151, 149, 147, 145
  }

  local PINK =
  {
    0, 207, 205, 203, 201, 199, 197, 195, 193
  }



  local colmaps =
  {
    WHITE, RED, GREEN, BLUE,
    BROWN, BRONZE, PINK
  }

  rand.shuffle(colmaps)

  gui.set_colormap(1, colmaps[1])
  gui.set_colormap(2, colmaps[2])
  gui.set_colormap(3, colmaps[3])
  gui.set_colormap(4, colmaps[4])

  -- patches
  gui.wad_logo_gfx("TILEEB33", "p", "PILL",   128,128, 1)
  gui.wad_logo_gfx("TILE0000", "p", "CARVE",   64, 64, 2)
  gui.wad_logo_gfx("TILE0009", "p", "BOLT",    64, 64, 3)

  -- flats
--[[ DISABLED : the Absolution.exe does not handle it (mucks up graphics)
  gui.wad_logo_gfx("O_PILL",   "f", "PILL",   64,64, 1)
  gui.wad_logo_gfx("O_CARVE",  "f", "CARVE",  64,64, 2)
  gui.wad_logo_gfx("O_BOLT",   "f", "BOLT",   64,64, 3)
--]]
end


function ABSOLUTION.all_done()
  ABSOLUTION.make_cool_gfx()
end


------------------------------------------------------------

UNFINISHED["absolution"] =
{
  label = "Doom64 TC"

  format = "doom"

  tables =
  {
    ABSOLUTION
  }

  hooks =
  {
    get_levels = ABSOLUTION.get_levels
    all_done   = ABSOLUTION.all_done
  }
}


OB_THEMES["absolution_tech"] =
{
  label = "Tech"
  for_games = { absolution=1 }
  name_theme = "TECH"
  mixed_prob = 50
}

UNFINISHED["absolution_hell"] =
{
  label = "Hell"
  for_games = { absolution=1 }
  name_theme = "GOTHIC"
  mixed_prob = 40
}

