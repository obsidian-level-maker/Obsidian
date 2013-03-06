----------------------------------------------------------------
--  GAME DEFINITION : DOOM, DOOM II
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2013 Andrew Apted
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

DOOM  = { }  -- common stuff

DOOM2 = { }  -- stuff specific to DOOM II


require "entities"
require "monsters"
require "weapons"
require "pickups"

require "materials"
require "themes"
require "levels"



DOOM.PARAMETERS =
{
  rails = true
  infighting = true
  raising_start = true
---!!!  light_brushes = true

  jump_height = 24

  map_limit = 12800

  -- this is roughly how many characters can fit on the
  -- intermission screens (the CWILVxx patches).  It does not
  -- reflect any buffer limits in the DOOM.EXE
  max_name_length = 28

  skip_monsters = { 15,25,35 }

  time_factor   = 1.0
  damage_factor = 1.0
  ammo_factor   = 1.0
  health_factor = 0.7
  monster_factor = 0.9
}

DOOM2.PARAMETERS =
{
  doom2_monsters = true
  doom2_weapons  = true
  doom2_skies    = true  -- RSKY# patches

  skip_monsters = { 20,30,45 }
}


----------------------------------------------------------------

DOOM.SKIN_DEFAULTS =
{
  tex_STARTAN3 = "?wall"
  tex_BLAKWAL1 = "?outer"
}


DOOM.SKINS =
{
  ----| STARTS |----

  Start_basic =
  {
    _file   = "start/basic.wad"
    _where  = "middle"

    top = "O_BOLT"
  }

  Start_ledge =
  {
    _prefab = "START_LEDGE"
    _where  = "edge"
    _long   = 192
    _deep   =  64

    wall = "CRACKLE2"
  }

  Start_Closet =
  {
    _file   = "start/closet1.wad"
    _where  = "closet"
    _fitted = "xy"


--[[
    step = "FLAT1"

    door = "BIGDOOR1"
    track = "DOORTRAK"

    support = "SUPPORT2"
    support_ox = 24

    special = 31  -- open and stay open
    tag = 0

    item1 = "bullet_box"
    item2 = "stimpack"
--]]
  }


  ----| EXITS |----

  Exit_switch =
  {
    _prefab = "WALL_SWITCH"
    _where  = "edge"
    _long   = 192
    _deep   = 64

    wall = "EXITSTON"

    switch="SW1HOT"
    special=11
    x_offset=0
    y_offset=0
  }

  Exit_pillar =
  {
    _file  = "exit/pillar1.wad",
    _where = "middle"
  }

  Exit_Pillar_tech =
  {
    _prefab = "EXIT_PILLAR",
    _where  = "middle"

    switch = "SW1COMP"
    exit = "EXITSIGN"
    exitside = "COMPSPAN"
    use_sign = 1
    special = 11
    tag = 0
  }

  Exit_Pillar_gothic =
  {
    _prefab = "EXIT_PILLAR",
    _where  = "middle"

    switch = { SW1LION=60, SW1GARG=30 }
    exit = "EXITSIGN"
    exitside = "COMPSPAN"
    use_sign = 1
    special = 11
    tag = 0
  }

  Exit_Pillar_urban =
  {
    _prefab = "EXIT_PILLAR",
    _where  = "middle"

    switch = "SW1WDMET"
    exit = "EXITSIGN"
    exitside = "COMPSPAN"
    use_sign = 1
    special = 11
    tag = 0
  }

  Exit_Closet_tech =
  {
    _file   = "exit/closet1.wad"
    _where  = "closet"
    _fitted = "xy"

--[[ FIXME
    door  = "EXITDOOR"
    track = "DOORTRAK"
    key   = "EXITDOOR"
    key_ox = 112

    inner = { STARGR2=30, STARBR2=30, STARTAN2=30,
              METAL4=15,  PIPE2=15,  SLADWALL=15,
              TEKWALL4=50 }

    ceil  = { TLITE6_5=40, TLITE6_6=20, GRNLITE1=20,
              CEIL4_3=10, SLIME15=10 }

    floor2 = { FLAT4=20, FLOOR0_1=20, FLOOR0_3=20, FLOOR1_1=20 }

    use_sign = 1
    exit = "EXITSIGN"
    exitside = "COMPSPAN"

    switch  = "SW1COMM"
    sw_side = "SHAWN2"

    special = 11
    tag = 0

    item1 = { stimpack=50, medikit=20, soul=1, none=30 }
    item2 = { shells=50, bullets=40, rocket=30, potion=20 }
--]]
  }

  Exit_Closet_hell =
  {
    _file   = "exit/closet1.wad"
    _where  = "closet"
    _fitted = "xy"

--[[ FIXME
    door  = "EXITDOOR"
    track = "DOORTRAK"
    key   = "SUPPORT3"
    key_ox = 24

    inner = { MARBGRAY=40, SP_HOT1=20, REDWALL=10,
              SKINMET1=10, SLOPPY2=10 }

    ceil = { FLAT5_6=20, LAVA1=5, FLAT10=10, FLOOR6_1=10 }

    floor2  = { SLIME09=10, FLOOR7_2=20, FLAT5_2=10, FLAT5_8=10 }

    use_sign = 1
    exit = "EXITSIGN"
    exitside = "COMPSPAN"

    switch  = { SW1LION=10, SW1SATYR=30, SW1GARG=20 }
    sw_side = "METAL"
    sw_oy   = 56

    special = 11
    tag = 0

    item1 = { stimpack=50, medikit=20, soul=1, none=30 }
    item2 = { shells=50, bullets=40, rocket=30, potion=20 }
--]]
  }

  Exit_Closet_urban =
  {
    _prefab = "EXIT_CLOSET"
    _where  = "closet"
    _fitted = "xy"

--[[ FIXME
    door  = "EXITDOOR"
    track = "DOORTRAK"
    key   = "SUPPORT3"
    key_ox = 24

    inner = { BIGBRIK3=20, WOOD9=10, STONE=10, WOODMET1=35,
              CEMENT9=5, PANEL6=20 }
    
    ceil = { RROCK04=20, RROCK13=20, RROCK03=10, 
             FLAT10=20, FLOOR6_2=10, FLAT4=20 }

    floor2  = { FLAT5_2=30, CEIL5_1=15, CEIL4_2=15,
                MFLR8_1=15, RROCK18=25, RROCK12=20 }

    use_sign = 1
    exit = "EXITSIGN"
    exitside = "COMPSPAN"

    switch  = { SW1BRNGN=30, SW1ROCK=10, SW1SLAD=20, SW1TEK=20 }
    sw_side = "BROWNGRN"
    sw_oy   = 60

    special = 11
    tag = 0

    item1 = { stimpack=50, medikit=20, soul=1, none=30 }
    item2 = { shells=50, bullets=40, rocket=30, potion=20 }
--]]
  }


  ----| STAIRS |----

  Stair_Up1 =
  {
    _prefab = "STAIR_6"
    _where  = "floor"
    _deltas = { 32,48,48,64,64,80 }
  }

  Stair_Up2 =
  {
    _prefab = "STAIR_W_SIDES"
    _where  = "floor"

    metal = "METAL"
    step  = "STEP1"
    top   = "FLOOR0_1"
  }

  Stair_Up3 =
  {
    _prefab = "STAIR_TRIANGLE"
    _where  = "floor"

    step = "STEP1"
    top = "FLOOR0_1"
  }

  Stair_Up4 =
  {
    _prefab = "STAIR_CIRCLE"
    _where  = "floor"

    step = "STEP5"
    top  = "FLOOR0_2"
  }

  Stair_Down1 =
  {
    _prefab = "NICHE_STAIR_8"
    _where  = "floor"
    _deltas = { -32,-48,-64,-64,-80,-96 }
  }


  Lift_Up1 =  -- Rusty
  {
    _prefab = "LIFT_UP"
    _where  = "floor"
    _tags   = 1
    _deltas = { 96,128,160,192 }

    lift = "SUPPORT3"
    top  = { STEP_F1=50, STEP_F2=50 }

    walk_kind   = 88
    switch_kind = 62
  }

  Lift_Down1 =  -- Shiny
  {
    _prefab = "LIFT_DOWN"
    _where  = "floor"
    _tags   = 1
    _deltas = { -96,-128,-160,-192 }

    lift = "SUPPORT2"
    top  = "FLAT20"

    walk_kind   = 88
    switch_kind = 62
  }


  ----| WALLS / CORNERS |----

  Fat_Outside_Corner1 =
  {
    _prefab = "FAT_CORNER_DIAG"
    _where  = "chunk"
  }


  ----| ITEM / KEY |----

  Item_niche =
  {
    _prefab = "ITEM_NICHE"
    _where  = "edge"
    _long   = 192
    _deep   = 64
  }

  Pedestal_1 =
  {
    _file  = "pedestal/ped.wad"
    _where = "middle"

    top  = "CEIL1_2"
    side = "METAL"
  }

  Item_Closet =
  {
    _prefab = "ITEM_CLOSET"
    _where  = "closet"
    _long   = { 192,384 }
    _deep   = { 192,384 }

    item = "soul"
  }

  Secret_Closet =
  {
    _prefab = "SECRET_NICHE_1"
    _where  = "closet"
    _tags   = 1
    _long   = { 192,384 }
    _deep   = { 192,384 }

    item = { backpack=50, blue_armor=50, soul=30, berserk=30,
             invul=10, invis=10, map=10, goggles=5 }

    special = 103  -- open and stay open
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

    pic = "SW1SATYR"    
  }


  ----| DOORS |----

  Door_silver =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _long   = 192
    _deep   = 48

    door_w = 128
    door_h = 72

    door  = "BIGDOOR1"
    track = "DOORTRAK"
    key   = "LITE3"
    step  = "STEP4"

    x_offset = 0
    y_offset = 0
    special = 1
    tag = 0
  }


--[[
  OLD_sw_blue2 =
  {
    prefab = "SWITCH_FLOOR_BEAM",
    skin =
    {
      switch_h=64,
      switch_w="SW1BLUE", side_w="COMPBLUE",
      switch_f="FLAT14", switch_h=64,

      beam_w="WOOD1", beam_f="FLAT5_2",

      x_offset=0, y_offset=56,
      special=103,
    }
  }

  OLD_sw_hot =
  {
    prefab = "SWITCH_PILLAR",
    skin =
    {
      switch_h=64,
      switch="SW1HOT", side="SP_HOT1", base="FLAT5_3",
      x_offset=0, y_offset=52,
      special=103,
    }

  }

  OLD_sw_skin =
  {
    prefab = "SWITCH_PILLAR",
    skin =
    {
      switch_h=64,
      switch="SW1SKIN", side="SKSNAKE2", base="SFLR6_4",
      x_offset=0, y_offset=52,
      special=103,
    }
  }

  OLD_sw_vine =
  {
    prefab = "SWITCH_PILLAR",
    skin =
    {
      switch_h=64,
      switch="SW1VINE", side="GRAYVINE", base="FLAT1",
      x_offset=0, y_offset=64,
      special=103,
    }
  }

  OLD_sw_metl =  -- NOT USED
  {
    prefab = "SWITCH_CEILING",
    environment = "indoor",
    skin =
    {
      switch_h=56,
      switch_w="SW1GARG", side_w="METAL",
      switch_c="CEIL5_2",

      beam_w="SUPPORT3", beam_c="CEIL5_2",

      x_offset=0, y_offset=64,
      special=23,
    }
  }

  OLD_sw_wood =
  {
    prefab = "SWITCH_PILLAR",
    skin =
    {
      switch_h=64,
      switch="SW1WOOD", side="WOOD1", base="FLAT5_2",
      x_offset=0, y_offset=56,
      special=103,
    }
  }

  OLD_sw_marble =
  {
    prefab = "SWITCH_PILLAR",
    skin =
    {
      switch="SW1GSTON", side="GSTONE1", base="FLOOR7_2",
      x_offset=0, y_offset=56,
      special=103,
    }
  }

  OLD_bar_wood =
  {
    prefab = "SWITCH_PILLAR",
    skin =
    {
      switch="SW1WOOD", side="WOOD9", base="FLAT5_2",
      x_offset=0, y_offset=56,
      special=23,
    }
  }

  OLD_bar_silver =
  {
    prefab = "SWITCH_PILLAR",
    skin =
    {
      switch="SW1COMM", side="SHAWN2", base="FLAT23",
      x_offset=0, y_offset=0,
      special=23,
    }
  }

  OLD_bar_metal =
  {
    prefab = "SWITCH_PILLAR",
    skin =
    {
      switch="SW1MET2", side="METAL2", base="CEIL5_2",
      x_offset=0, y_offset=0,
      special=23,
    }
  }

  OLD_bar_gray =
  {
    prefab = "SWITCH_PILLAR",
    skin =
    {
      switch="SW1GRAY1", side="GRAY1", base="FLAT1",
      x_offset=0, y_offset=64,
      special=23,
    }
  }
--]]


  ---| LOCKED DOORS |---

  Locked_kc_blue =
  {
    _file   = "door/key_door.wad"
    _where  = "edge"
    _fitted = "xy"
    _key    = "kc_blue"
    _long   = 192
    _deep   = 48

    tex_DOORRED = "DOORBLU";
    line_33 = 32

    door_w = 128
    door_h = 112

    key = "DOORBLU"
    door = "BIGDOOR3"
    door_c = "FLOOR7_2"
    step = "STEP4"
    track = "DOORTRAK"

    special = 32
    tag = 0  -- kind_mult=26
  }

  Locked_kc_yellow =
  {
    _file   = "door/key_door.wad"
    _where  = "edge"
    _fitted = "xy"
    _key    = "kc_yellow"
    _long   = 192
    _deep   = 48

    tex_DOORRED = "DOORYEL";
    line_33 = 34

    door_w = 128
    door_h = 112

    key = "DOORYEL"
    door = "BIGDOOR4"
    door_c = "FLOOR3_3"
    step = "STEP4"
    track = "DOORTRAK"

    special = 34
    tag = 0  -- kind_mult=27
  }

  Locked_kc_red =
  {
    _file   = "door/key_door.wad"
    _where  = "edge"
    _fitted = "xy"
    _key    = "kc_red"
    _long   = 192
    _deep   = 48

    door_w = 128
    door_h = 112

    key = "DOORRED"
    door = "BIGDOOR2"
    door_c = "FLAT1"
    step = "STEP4"
    track = "DOORTRAK"

    special = 33
    tag = 0  -- kind_mult=28
  }


  Locked_ks_blue =
  {
    _file   = "door/key_door.wad"
    _where  = "edge"
    _fitted = "xy"
    _key    = "ks_blue"
    _long   = 192
    _deep   = 48

    tex_DOORRED = "DOORBLU2";
    line_33 = 32

    door_w = 128
    door_h = 112

    key = "DOORBLU2"
    key_ox = 4
    key_oy = -10
    door = "BIGDOOR7"
    door_c = "FLOOR7_2"
    step = "STEP4"
    track = "DOORTRAK"

    special = 32
    tag = 0  -- kind_mult=26
  }

  Locked_ks_yellow =
  {
    _file   = "door/key_door.wad"
    _where  = "edge"
    _fitted = "xy"
    _key    = "ks_yellow"
    _long   = 192
    _deep   = 48

    tex_DOORRED = "DOORYEL2";
    line_33 = 34

    door_w = 128
    door_h = 112

    key = "DOORYEL2"
    key_ox = 4
    key_oy = -10
    door = "BIGDOOR7"
    door_c = "FLOOR3_3"
    step = "STEP4"
    track = "DOORTRAK"

    special = 34
    tag = 0  -- kind_mult=27
  }

  Locked_ks_red =
  {
    _file   = "door/key_door.wad"
    _where  = "edge"
    _fitted = "xy"
    _key    = "ks_red"
    _long   = 192
    _deep   = 48

    tex_DOORRED = "DOORRED2";

    door_w = 128
    door_h = 112

    key = "DOORRED2"
    key_ox = 4
    key_oy = -10
    door = "BIGDOOR7"
    door_c = "FLAT1"
    step = "STEP4"
    track = "DOORTRAK"

    special = 33
    tag = 0  -- kind_mult=28
  }

  -- narrow versions of above doors

  Locked_kc_blue_NAR =
  {
    _copy = "Locked_kc_blue"
    _narrow = 1

    door_w = 64
    door_h = 72
    door   = "DOOR3"
    door_c = "FLAT1"
  }

  Locked_kc_yellow_NAR =
  {
    _copy = "Locked_kc_yellow"
    _narrow = 1

    door_w = 64
    door_h = 72
    door   = "DOOR3"
    door_c = "FLAT1"
  }

  Locked_kc_red_NAR =
  {
    _copy = "Locked_kc_red"
    _narrow = 1

    door_w = 64
    door_h = 72
    door   = "DOOR3"
    door_c = "FLAT1"
  }

  Locked_ks_blue_NAR =
  {
    _copy = "Locked_ks_blue"
    _narrow = 1

    door_w = 64
    door_h = 72
    door   = "DOOR3"
    door_c = "FLAT1"
  }

  Locked_ks_yellow_NAR =
  {
    _copy = "Locked_ks_yellow"
    _narrow = 1

    door_w = 64
    door_h = 72
    door   = "DOOR3"
    door_c = "FLAT1"
  }

  Locked_ks_red_NAR =
  {
    _copy = "Locked_ks_red"
    _narrow = 1

    door_w = 64
    door_h = 72
    door   = "DOOR3"
    door_c = "FLAT1"
  }


  MiniHall_Door_tech =
  {
    _prefab = "MINI_DOOR1"
    _shape  = "I"
    _delta  = 0
    _door   = 1

    door   = { BIGDOOR3=50, BIGDOOR4=40, BIGDOOR2=15 }
    track  = "DOORTRAK"
    step   = "STEP4"
    metal  = "DOORSTOP"
    lite   = "LITE5"
    c_lite = "TLITE6_1"
  }

  MiniHall_Door_hell =
  {
    _prefab = "MINI_DOOR1"
    _shape  = "I"
    _delta  = 0
    _door   = 1

    door   = { BIGDOOR6=50 }
    track  = "DOORTRAK"
    step   = "STEP4"
    metal  = "METAL"
    lite   = "FIREWALL"
  }


  ---| SWITCHED DOORS |---

  Door_SW_blue =
  {
    _file   = "door/sw_door1.wad"
    _where  = "edge"
    _fitted = "xy"
    _switch = "sw_blue"
    _long = 256
    _deep = 48

    door_w = 128
    door_h = 112

    key = "COMPBLUE"
    door = "BIGDOOR3"
    door_c = "FLOOR7_2"
    step = "COMPBLUE"
    track = "DOORTRAK"
    frame = "FLAT14"
    door_h = 112
    special = 0
  }

  Door_SW_blue_NAR =
  {
    _copy = "Door_SW_blue"
    _narrow = 1

    door_w = 64
    door_h = 72
    door   = "DOOR1"
    door_c = "FLAT23"
  }

  Switch_blue1 =
  {
    _file   = "switch/small2.wad"
    _where  = "middle"
    _switch = "sw_blue"

    switch_h = 64
    switch = "SW1BLUE"
    side = "COMPBLUE"
    base = "COMPBLUE"
    x_offset = 0
    y_offset = 50
    special = 103
  }


  Door_SW_red =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _switch = "sw_red"
    _long = 256
    _deep = 48

    door_w = 128
    door_h = 112

    key = "REDWALL"
    door = "BIGDOOR2"
    door_c = "FLAT1"
    step = "REDWALL"
    track = "DOORTRAK"
    frame = "FLAT5_3"
    door_h = 112
    special = 0
  }

  Door_SW_red_NAR =
  {
    _copy = "Door_SW_red"
    _narrow = 1

    door_w = 64
    door_h = 72
    door   = "DOOR1"
    door_c = "FLAT23"
  }

  Switch_red1 =
  {
    _prefab = "SMALL_SWITCH"
    _where  = "middle"
    _switch = "sw_red"

    switch_h = 64
    switch = "SW1HOT"
    side = "SP_HOT1"
    base = "SP_HOT1"
    x_offset = 0
    y_offset = 50
    special = 103
  }


  Door_SW_pink =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _switch = "sw_pink"
    _long   = 256
    _deep   = 48

    door_w = 128
    door_h = 112

    key = "SKINFACE"
    door = "BIGDOOR4"
    door_c = "FLOOR7_2"
    step = "SKINFACE"
    track = "DOORTRAK"
    frame = "SKINFACE"
    door_h = 112
    special = 0
  }

  Door_SW_pink_NAR =
  {
    _copy = "Door_SW_pink"
    _narrow = 1

    door_w = 64
    door_h = 72
    door   = "DOOR1"
    door_c = "FLAT23"
  }

  Switch_pink1 =
  {
    _prefab = "SMALL_SWITCH"
    _where  = "middle"
    _switch = "sw_pink"

    switch_h = 64
    switch = "SW1SKIN"
    side = "SKIN2"
    base = "SKIN2"
    x_offset = 0
    y_offset = 50
    special = 103
  }


  Door_SW_vine =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _switch = "sw_vine"
    _long   = 256
    _deep   = 48

    door_w = 128
    door_h = 112

    key = "GRAYVINE"
    door = "BIGDOOR4"
    door_c = "FLOOR7_2"
    step = "GRAYVINE"
    track = "DOORTRAK"
    frame = "FLAT1"
    door_h = 112
    special = 0
  }

  Door_SW_vine_NAR =
  {
    _copy = "Door_SW_vine"
    _narrow = 1

    door_w = 64
    door_h = 72
    door   = "DOOR1"
    door_c = "FLAT23"
  }

  Switch_vine1 =
  {
    _prefab = "SMALL_SWITCH"
    _where  = "middle"
    _switch = "sw_vine"

    switch_h = 64
    switch = "SW1VINE"
    side = "GRAYVINE"
    base = "GRAYVINE"
    x_offset = 0
    y_offset = 62
    special = 103
  }


  ---| HALLWAY PIECES |---

  Hall_Basic_I =
  {
    _file   = "hall/trim1_i_win.wad"
    _shape  = "I"
    _fitted = "xy"
  }

  Hall_Basic_C =
  {
    _file   = "hall/trim1_c.wad"
    _shape  = "C"
    _fitted = "xy"
  }

  Hall_Basic_T =
  {
    _file   = "hall/trim1_t_lit.wad"
    _shape  = "T"
    _fitted = "xy"
  }

  Hall_Basic_P =
  {
    _file   = "hall/trim1_p.wad"
    _shape  = "P"
    _fitted = "xy"
  }

  Hall_Basic_I_Stair =
  {
    _file   = "hall/trim1_st.wad"
    _shape  = "IS"
    _fitted = "xy"

    step = "STEP3"
    support = "SUPPORT2"
    support_ox = 24
  }

  Hall_Basic_I_Lift =
  {
    _file   = "hall/trim1_lf.wad"
    _shape  = "IL"
    _fitted = "xy"
    _z_ranges = { {64,0}, {64,0,"?stair_h-64"}, {128,0} }
    _tags   = 1

    lift = "SUPPORT3"
    top  = { STEP_F1=50, STEP_F2=50 }

    raise_W1 = 130
    lower_WR = 88  -- 120
    lower_SR = 62  -- 123
  }


  Hall_Thin_I =
  {
    _prefab = "HALL_THIN_I"
    _shape  = "I"
  }

  Hall_Thin_C =
  {
    _prefab = "HALL_THIN_C"
    _shape  = "C"
  }

  Hall_Thin_T =
  {
    _prefab = "HALL_THIN_T"
    _shape  = "T"

    lamp_ent = "lamp"
  }

  -- TODO: Hall_Thin_P

  Hall_Thin_I_Bend =
  {
    _prefab = "HALL_THIN_I_BEND"
    _shape  = "I"
  }

  Hall_Thin_I_Bulge =
  {
    _prefab = "HALL_THIN_I_BULGE"
    _shape  = "I"
    _long   = 192
    _deep   = { 192,384 }
    _in_between = 1

    lamp = "TLITE6_1"
  }

  Hall_Thin_P_Oh =
  {
    _prefab = "HALL_THIN_OH"
    _shape  = "P"
    _long   = 384
    _deep   = 384
    _in_between = 1

    pillar = { WOODMET1=70, TEKLITE=20, SLADWALL=20 }
    niche  = "DOORSTOP"

    torch_ent = { red_torch_sm=50, green_torch_sm=10 }

    effect = 17
  }

  Hall_Thin_I_Oh =
  {
    _copy  = "Hall_Thin_P_Oh"
    _shape = "I"

    east_h = 128
    west_h = 128
  }

  Hall_Thin_C_Oh =
  {
    _copy  = "Hall_Thin_P_Oh"
    _shape = "C"

    east_h  = 128
    north_h = 128
  }

  Hall_Thin_T_Oh =
  {
    _copy  = "Hall_Thin_P_Oh"
    _shape = "T"

    north_h = 128
  }

  Hall_Thin_I_Stair =
  {
    _prefab = "HALL_THIN_I_STAIR"
    _shape  = "IS"

    step = "STEP1"
  }

  -- TODO: Hall_Thin_I_Lift


  Hall_Cavey_I =
  {
    _prefab = "HALL_CAVEY_I"
    _shape  = "I"
  }

  Hall_Cavey_C =
  {
    _prefab = "HALL_CAVEY_C"
    _shape  = "C"
  }

  Hall_Cavey_T =
  {
    _prefab = "HALL_CAVEY_T"
    _shape  = "T"
  }

  Hall_Cavey_P =
  {
    _prefab = "HALL_CAVEY_P"
    _shape  = "P"
  }

  Hall_Cavey_I_Stair =
  {
    _prefab = "HALL_CAVEY_I_STAIR"
    _shape  = "IS"
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

    support = "SUPPORT3"
    torch_ent = "green_torch_sm"
  }

  Sky_Hall_I_Stair =
  {
    _prefab = "SKY_HALL_I_STAIR"
    _shape  = "IS"
    _need_sky = 1

    step = "STEP5"
  }


  Secret_Mini =
  {
    _prefab = "SECRET_MINI"
    _shape  = "I"
    _tags   = 1

    pic   = "O_NEON"
    inner = "COMPSPAN"
    metal = "METAL"
  }


  ---| WIDE JOINERS |---

  Wide_TriPillar =
  {
    _file   = "joiner/tri_pillar.wad"
    _shape  = "I"
    _fitted = "xy"
  }


  ---| BIG JUNCTIONS |---

  Junc_Octo_I =
  {
    _prefab = "JUNCTION_OCTO"
    _shape  = "I"

    hole = "_SKY"

    east_wall_q = 1
    west_wall_q = 1
  }

  Junc_Octo_C =
  {
    _prefab = "JUNCTION_OCTO"
    _shape  = "C"

    hole = "_SKY"

    north_wall_q = 1
     east_wall_q = 1
  }

  Junc_Octo_T =
  {
    _prefab = "JUNCTION_OCTO"
    _shape  = "T"

    hole = "_SKY"

    north_wall_q = 1
  }

  Junc_Octo_P =
  {
    _prefab = "JUNCTION_OCTO"
    _shape  = "P"

    hole = "_SKY"

    -- leave all walls open
  }


  Junc_Nuke_Islands =
  {
    _prefab = "JUNCTION_NUKEY_C"
    _shape  = "C"
    _liquid = 1
    _long   = { 576,576 }
    _deep   = { 576,576 }

    island = { FLOOR3_3=50, FLOOR0_3=50, MFLR8_2=10 }
    ceil   = { CEIL5_1=30, FLAT10=10, CEIL3_5=40, CEIL4_2=30 }

    support = "SUPPORT3"
    support_ox = 24

    lamp = { TLITE6_5=50, TLITE6_6=10, TLITE6_1=10, FLOOR1_7=5 }
  }


  Junc_Circle_gothic_P =
  {
    _file   = "junction/circle_p.wad"
    _fitted = "xy"
    _shape  = "P"

    floor  = "CEIL3_5"
    circle = "CEIL3_3"
    step   = "STEP6"

    plinth = "MARBGRAY"
    plinth_top = "FLOOR7_2"
    plinth_ent = "evil_eye"

    billboard = "SW2SATYR"
    bill_side = "METAL"
    bill_oy   = 52

    torch_ent = "red_torch"
  }

  Junc_Circle_gothic_I =
  {
    _copy  = "Junc_Circle_gothic_P"
    _shape = "I"

    east_h = 0
    west_h = 0
  }

  Junc_Circle_gothic_C =
  {
    _copy  = "Junc_Circle_gothic_P"
    _shape = "C"

    east_h = 0
    north_h = 0
  }

  Junc_Circle_gothic_T =
  {
    _copy  = "Junc_Circle_gothic_P"
    _shape = "T"

    north_h = 0
  }


  Junc_Circle_tech_P =
  {
    _prefab = "JUNCTION_CIRCLE"
    _shape  = "P"

    floor  = "CEIL3_5"
    circle = "CEIL3_3"
    step   = "STEP6"

    plinth = "TEKWALL4"
    plinth_top = "CEIL5_2"
    plinth_ent = "evil_eye"

    billboard = { COMPSTA2=50, COMPSTA1=10 }
    bill_side = "FLAT23"
    bill_oy   = 0

    torch_ent = "mercury_lamp"
  }

  Junc_Circle_tech_I =
  {
    _copy  = "Junc_Circle_tech_P"
    _shape = "I"

    east_h = 0
    west_h = 0
  }

  Junc_Circle_tech_C =
  {
    _copy  = "Junc_Circle_tech_P"
    _shape = "C"

    east_h = 0
    north_h = 0
  }

  Junc_Circle_tech_T =
  {
    _copy  = "Junc_Circle_tech_P"
    _shape = "T"

    north_h = 0
  }


  Junc_Spokey_P =
  {
    _prefab = "JUNCTION_SPOKEY"
    _shape  = "P"

    metal = "METAL"
    floor = "FLOOR0_3"
  }

  Junc_Spokey_I =
  {
    _copy  = "Junc_Spokey_P"
    _shape = "I"

    east_h = 0
    west_h = 0
  }

  Junc_Spokey_C =
  {
    _copy  = "Junc_Spokey_P"
    _shape = "C"

    east_h = 0
    north_h = 0
  }

  Junc_Spokey_T =
  {
    _copy  = "Junc_Spokey_P"
    _shape = "T"

    north_h = 0
  }


  Junc_Nuke_Pipes_P =
  {
    _prefab = "JUNCTION_NUKE_PIPES"
    _shape  = "P"

    main_wall = "BLAKWAL1"
    high_ceil = "CEIL4_1"
    low_ceil = "COMPSPAN"
    low_floor = "FLOOR7_1"  -- CEIL5_1

    trim = "METAL"
    lite = "LITE3"
    pipe = "METAL4"
  }

  Junc_Nuke_Pipes_I =
  {
    _copy  = "Junc_Nuke_Pipes_P"
    _shape = "I"

    east_h = -24
    west_h = -24
  }

  Junc_Nuke_Pipes_C =
  {
    _copy  = "Junc_Nuke_Pipes_P"
    _shape = "C"

    east_h  = -24
    north_h = -24
  }

  Junc_Nuke_Pipes_T =
  {
    _copy  = "Junc_Nuke_Pipes_P"
    _shape = "T"

    north_h = -24
  }


  Junc_Ledge_T =
  {
    _prefab = "JUNCTION_LEDGE_1"
    _shape  = "T"
    _heights = { 0,64,64,64 }
    _floors  = { "floor1", "floor2", "floor2", "floor2" }

    floor1 = "FLOOR0_1"
    ceil1  = "CEIL3_5"

    floor2 = "FLAT4"
    -- ceil2  = "FLAT5_3"
    low_trim = "GRAY7"
    high_trim = "GRAY7"

    support = "METAL2"
    step = "STEP1"
    top = "CEIL5_1"

    lamp_ent = "lamp"
  }

  Junc_Ledge_P =
  {
    _copy = "Junc_Ledge_T"
    _shape  = "P"

    north_h = 64
  }


  Junc_Well_P =
  {
    _prefab = "JUNCTION_WELL_1"
    _shape  = "P"
    _liquid = 1
    _heights = { 0,-84,84,168 }

    brick  = "BIGBRIK2"
    top    = "MFLR8_1"
    floor1 = "BIGBRIK1"
    step   = "ROCK3"

    gore_ent  = "skull_pole"

    torch_ent = { blue_torch_sm=50, blue_torch=50,
                  red_torch_sm=10,  red_torch=10 }
  }

  Junc_Well_T =
  {
    _copy = "Junc_Well_P"
    _shape  = "T"

    north_h = 296  -- closed
  }

  Junc_Well_I =
  {
    _copy = "Junc_Well_P"
    _shape  = "I"

    east_h = 212  -- closed
    west_h =  44  --
  }


  ---| TELEPORTERS |---

  Teleporter1 =
  {
    _file   = "teleport/pad1.wad"
    _where  = "middle"

    tag_1 = "?out_tag"
    tag_2 = "?in_tag"

--[[
    tele = { GATE1=60, GATE2=60, GATE3=30 }
    side = "METAL"

    x_offset = 0
    y_offset = 0
    peg = 1

    special = 97
    effect = 8
    light = 255
--]]
  }

  Teleporter_Closet =
  {
    _file  = "teleport/closet1.wad"
    _where = "closet"
    _fitted = "xy"
    _long   = 256

    tag_1 = "?out_tag"
    tag_2 = "?in_tag"
--[[
    tele = "GATE4"
    tele_side = "METAL"

    inner = "REDWALL"
    floor = "CEIL3_3"
    ceil  = "CEIL3_3"
    step  = "STEP1"

    special = 97
--]]
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


  ---| WINDOWS |---

  Window1 =
  {
    _file   = "window/window1.wad"
    _where  = "edge"
    _fitted = "xy"
    _long   = 192
    _deep   = 24

  }


  ---| FENCES |---

  Fence1 =
  {
    _file   = "fence/fence1.wad"
    _where  = "edge"
    _fitted = "xy"
    _long   = 192
    _deep   = 32

    fence = "ICKWALL7"
    metal = "METAL"
    rail  = "MIDBARS3"
  }


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


  ---| PICTURES |---

  Pic_Pill =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 256

    pic   = "O_PILL"
    pic_w = 128
    pic_h = 32

    light = 64
  }

  Pic_Carve =
  {
    _file   = "wall/pic_64x64.wad"
    _where  = "edge"
    _fitted = "xy"
    _bound_z1 = 0
    _bound_z2 = 128
    _long   = 256

    tex_GRAYPOIS = "O_CARVE"
  }

  Pic_Neon =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 256

    pic   = "O_NEON"
    pic_w = 128
    pic_h = 128

    light = 64
    effect = 8
    fx_delta = -64
  }


  -- techy --

  Pic_Computer =
  {
    _file   = "wall/pic_128x48.wad"
    _where  = "edge"
    _fitted = "xy"
    _bound_z1 = 0
    _bound_z2 = 112
    _long   = 256

    pic   = { COMPSTA1=50, COMPSTA2=50 }
    pic_w = 128
    pic_h = 48

    light = 48
    effect = { [0]=90, [1]=5 }  -- sometimes blink
    fx_delta = -47
  }

  Pic_Silver3 =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 256

    pic   = "SILVER3"
    pic_w = 64
    pic_h = 96
    y_offset = 16

    light = 48
    effect = { [0]=90, [1]=5 }  -- sometimes blink
    fx_delta = -47
  }

  Pic_TekWall =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 256

    pic   = { TEKWALL1=50, TEKWALL4=50 }
    pic_w = 144
    pic_h = 128
    y_offset = 24

    light = 32
    scroll = 48
  }

  Pic_LiteGlow =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 64
    _repeat = 96

    pic   = "LITE3"
    pic_w = 32
    pic_h = 128

    light = 64
    effect = { [8]=90, [17]=5 }  -- sometimes flicker
    fx_delta = -63
  }

  Pic_LiteGlowBlue =
  {
    _copy = "Pic_LiteGlow"

    pic = "LITEBLU4"
  }

  Pic_LiteFlash =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 64

    pic   = "LITE3"
    pic_w = 32
    pic_h = 128

    light = 64
    effect = { [1]=90, [2]=20 }
    fx_delta = -63
  }

  -- hellish --

  Pic_FireWall =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 256

    pic   = "FIREWALL"
    pic_w = 128
    pic_h = 112

    light = 64
--  effect = 17
--  fx_delta = -16
  }

  Pic_MarbFace =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 256

    pic   = { MARBFAC2=50, MARBFAC3=50 }
    pic_w = 128
    pic_h = 128

    light = 16
  }

  Pic_DemonicFace =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 256

    pic   = "MARBFACE"
    pic_w = 128
    pic_h = 128

    light = 32
  }

  Pic_SkinScroll =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 256

    pic   = "SKINFACE"
    pic_w = 144
    pic_h = 80
    
    y_offset = 24

    light = 32
    scroll = 48
  }

  Pic_FaceScroll =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 256

    pic   = "SP_FACE1"
    pic_w = 144
    pic_h = 96

    light = 32
    scroll = 48
  }

  -- urban --

  Pic_Adolf =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 256

    pic   = "ZZWOLF7"
    pic_w = 128
    pic_h = 128

    light = 16
  }

  Pic_Eagle =
  {
    _copy = "Pic_Adolf"

    pic = "ZZWOLF6"
  }

  Pic_Wreath =
  {
    _copy = "Pic_Adolf"

    pic = "ZZWOLF13"
  }

  Pic_MetalFace =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = { SW1SATYR=50, SW1GARG=50, SW1LION=50 }
    pic_w = 64
    pic_h = 72
    y_offset = 56

    light = 16
  }

  Pic_MetalFaceLit =
  {
    _copy = "Pic_MetalFace"

    pic = { SW2SATYR=50, SW2GARG=50, SW2LION=50 }

    light = 32
  }


  ---| CAGES |---

  Fat_Cage1 =
  {
    _file   = "cage/fat_edge.wad"
    _where  = "chunk"
    _fitted = "xy"

    rail = "MIDBARS3"    
  }

  Fat_Cage_W_Bars =
  {
    _prefab = "FAT_CAGE_W_BARS"
    _where  = "chunk"

    bar = "METAL"
  }


  ---| DECORATION |---

  Pillar_2 =
  {
    _prefab = "PILLAR_2"
    _where  = "middle"
    _radius = 40
---!!    _long   = 384
---!!    _deep   = 384

    base   = "GRAY1"
    pillar = "METAL"
  }

  RoundPillar =
  {
    _prefab = "ROUND_PILLAR"
    _where  = "middle"
    _radius = 32

    pillar = "TEKLITE"
  }

  Crate1 =
  {
    _prefab = "CRATE"
    _where  = "middle"
    _radius = 32

    crate = "CRATE1"
  }

  Crate2 =
  {
    _prefab = "CRATE"
    _where  = "middle"
    _radius = 32

    crate = "CRATE2"
  }

  CrateWOOD =
  {
    _prefab = "CRATE"
    _where  = "middle"
    _radius = 32

    crate = "WOOD3"
  }

  CrateICK =
  {
    _prefab = "CRATE"
    _where  = "middle"
    _radius = 32

    crate = "ICKWALL4"
  }

} -- end of DOOM.SKINS



----------------------------------------------------------------

DOOM.PLAYER_MODEL =
{
  doomguy =
  {
    stats   = { health=0 }
    weapons = { pistol=1, fist=1 }
  }
}


DOOM2.SECRET_EXITS =
{
  MAP15 = true
  MAP31 = true
}


DOOM2.EPISODES =
{
  episode1 =
  {
    sky_light = 0.75
  }

  episode2 =
  {
    sky_light = 0.50
  }

  episode3 =
  {
    sky_light = 0.75
  }
}


DOOM2.ORIGINAL_THEMES =
{
  "doom_tech"
  "doom_urban"
  "doom_hell"
}


------------------------------------------------------------


function DOOM2.setup()
  -- nothing needed
end


function DOOM2.get_levels()
  local MAP_NUM = 11

  if OB_CONFIG.length == "single" then MAP_NUM = 1  end
  if OB_CONFIG.length == "few"    then MAP_NUM = 4  end
  if OB_CONFIG.length == "full"   then MAP_NUM = 32 end

  gotcha_map = rand.pick{17,18,19}
  gallow_map = rand.pick{24,25,26}

  local EP_NUM = 1
  if MAP_NUM > 11 then EP_NUM = 2 end
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
      ep_index = 3 ; ep_along = 0.35
    elseif map > 20 then
      ep_index = 3 ; ep_along = (map - 20) / 10
    elseif map > 11 then
      ep_index = 2 ; ep_along = (map - 11) / 9
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

    local ep_info = DOOM2.EPISODES["episode" .. ep_index]
    assert(ep_info)
    assert(ep_along <= 1)

    local LEV =
    {
      episode = EPI

      name  = string.format("MAP%02d", map)
      patch = string.format("CWILV%02d", map-1)

      ep_along = ep_along

      sky_light = ep_info.sky_light
    }

    table.insert( EPI.levels, LEV)
    table.insert(GAME.levels, LEV)

    LEV.secret_exit = GAME.SECRET_EXITS[LEV.name]

    if map == 31 or map == 32 then
      -- secret levels are easy
      LEV.mon_along = 0.35
    elseif OB_CONFIG.length == "single" then
      LEV.mon_along = ep_along
    else
      -- difficulty ramps up over whole wad
      LEV.mon_along = map * 1.4 / math.min(MAP_NUM, 20)
    end

    -- secret levels
    if map == 31 or map == 32 then
      LEV.theme_name = "doom_wolf1"
      LEV.theme = GAME.LEVEL_THEMES[LEV.theme_name]

      LEV.name_theme = "URBAN"
    end

    if map == 23 then
      LEV.style_list = { barrels = { heaps=100 } }
    end

    -- prebuilt levels
    local pb_name = LEV.name

    if map == gotcha_map then pb_name = "GOTCHA" end
    if map == gallow_map then pb_name = "GALLOW" end
    
    LEV.prebuilt = GAME.PREBUILT_LEVELS[pb_name]

    if LEV.prebuilt then
      LEV.name_theme = LEV.prebuilt.name_theme or "BOSS"
    end

    if MAP_NUM == 1 or (map % 10) == 3 then
      LEV.demo_lump = string.format("DEMO%d", ep_index)
    end
  end
end


DOOM.LEVEL_GFX_COLORS =
{
  gold   = { 0,47,44, 167,166,165,164,163,162,161,160, 225 }
  silver = { 0,246,243,240, 205,202,200,198, 196,195,194,193,192, 4 }
  bronze = { 0,2, 191,188, 235,232, 221,218,215,213,211,209 }
  iron   = { 0,7,5, 111,109,107,104,101,98,94,90,86,81 }
}


function DOOM.make_cool_gfx()
  local GREEN =
  {
    0, 7, 127, 126, 125, 124, 123,
    122, 120, 118, 116, 113
  }

  local BRONZE_2 =
  {
    0, 2, 191, 189, 187, 235, 233,
    223, 221, 219, 216, 213, 210
  }

  local RED =
  {
    0, 2, 188,185,184,183,182,181,
    180,179,178,177,176,175,174,173
  }


  local colmaps =
  {
    BRONZE_2, GREEN, RED,

    DOOM.LEVEL_GFX_COLORS.gold,
    DOOM.LEVEL_GFX_COLORS.silver,
    DOOM.LEVEL_GFX_COLORS.iron,
  }

  rand.shuffle(colmaps)

  gui.set_colormap(1, colmaps[1])
  gui.set_colormap(2, colmaps[2])
  gui.set_colormap(3, colmaps[3])
  gui.set_colormap(4, DOOM.LEVEL_GFX_COLORS.iron)

  -- patches (CEMENT1 .. CEMENT4)
  gui.wad_logo_gfx("WALL52_1", "p", "PILL",   128,128, 1)
  gui.wad_logo_gfx("WALL53_1", "p", "BOLT",   128,128, 2)
  gui.wad_logo_gfx("WALL55_1", "p", "RELIEF", 128,128, 3)
  gui.wad_logo_gfx("WALL54_1", "p", "CARVE",  128,128, 4)

  -- flats
  gui.wad_logo_gfx("O_PILL",   "f", "PILL",   64,64, 1)
  gui.wad_logo_gfx("O_BOLT",   "f", "BOLT",   64,64, 2)
  gui.wad_logo_gfx("O_RELIEF", "f", "RELIEF", 64,64, 3)
  gui.wad_logo_gfx("O_CARVE",  "f", "CARVE",  64,64, 4)
end


function DOOM.make_level_gfx()
  assert(LEVEL.description)
  assert(LEVEL.patch)

  -- decide color set
  if not GAME.level_gfx_colors then
    local kind = rand.key_by_probs(
    {
      gold=12, silver=3, bronze=8, iron=10
    })

    GAME.level_gfx_colors = assert(DOOM.LEVEL_GFX_COLORS[kind])
  end

  gui.set_colormap(1, GAME.level_gfx_colors)

  gui.wad_name_gfx(LEVEL.patch, LEVEL.description, 1)
end


function DOOM2.end_level()
  if LEVEL.description and LEVEL.patch then
    DOOM.make_level_gfx()
  end
end


function DOOM2.all_done()
  DOOM.make_cool_gfx()

  gui.wad_merge_sections("doom_falls.wad");
  gui.wad_merge_sections("vine_dude.wad");

  if OB_CONFIG.length == "full" then
    gui.wad_merge_sections("freedoom_face.wad");
  end
end



------------------------------------------------------------


OB_GAMES["doom2"] =
{
  label = "Doom 2"

  priority = 99  -- keep at top

  format = "doom"

  tables =
  {
    DOOM, DOOM2
  }

  hooks =
  {
    setup        = DOOM2.setup
    get_levels   = DOOM2.get_levels
    end_level    = DOOM2.end_level
    all_done     = DOOM2.all_done
  }
}


