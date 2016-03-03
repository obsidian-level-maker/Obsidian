----------------------------------------------------------------
--  GAME DEF : HacX 1.2
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2009-2011 Andrew Apted
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

HACX = { }

HACX.ENTITIES =
{
  --- special stuff ---
  player1 = { id=1, r=16, h=56 }
  player2 = { id=2, r=16, h=56 }
  player3 = { id=3, r=16, h=56 }
  player4 = { id=4, r=16, h=56 }

  dm_player     = { id=11, r=16, h=56 }
  teleport_spot = { id=14, r=16, h=56 }

  --- keys ---
  k_password = { id=5 }
  k_ckey     = { id=6 }
  k_keycard  = { id=13 }

  kz_red     = { id=38 }
  kz_yellow  = { id=39 }
  kz_blue    = { id=40 }

  -- TODO: POWERUPS

  --- scenery ---
  chair      = { id=35, r=24, h=40 }

  -- TODO: all other scenery!!
}


HACX.PARAMETERS =
{
  rails = true
  light_brushes = true

  jump_height = 24

  max_name_length = 28

  skip_monsters = { 10,30 }

  time_factor   = 1.0
  damage_factor = 1.0
  ammo_factor   = 0.8
  health_factor = 0.7
}


----------------------------------------------------------------

HACX.MATERIALS =
{
  -- FIXME!!! very incomplete

  -- special materials --
  _ERROR = { t="HW209", f="RROCK03" }
  _SKY   = { t="HW209", f="F_SKY1" }


  -- general purpose --

  METAL  = { t="HW209", f="RROCK03" }

  LIFT   = { t="HW176", f="DEM1_1" }


  -- walls --

  BROWNHUG = { t="BROWNHUG", f="BLOOD1" }

  DOORTRAK = { t="HW209", f="RROCK03" }

  HD6   = { t="HD6",   f="RROCK03" }
  HW510 = { t="HW510", f="SLIME15" }
  HW511 = { t="HW511", f="SLIME14" }
  HW512 = { t="HW512", f="SLIME13" }
  HW513 = { t="HW513", f="SLIME16" }

  TECHY1 = { t="HW172", f="FLAT5_1" }
  WOODY1 = { t="COMPTALL", f="RROCK14" }
  BLOCKY1 = { t="HW219", f="RROCK11" }
  BLOCKY2 = { t="MIDBRONZ", f="CONS1_1" }

  CAVEY1 = { t="MARBFAC4", f="RROCK12" }
  DIRTY1 = { t="PANCASE1", f="RROCK15" }
  DIRTY2 = { t="PANEL2",   f="RROCK15" }
  STONY1 = { t="PLANET1",  f="GRNROCK" }

  GRAY_ROCK = { t="HW185", f="FLOOR0_1" }

  DARK_CONC = { t="HW205", f="CONS1_5" }


  LITE2 = { t="LITE2", f="DEM1_2" }

  MODWALL3 = { t="MODWALL3", f="CEIL3_3" }


  TECH_PIC1 = { t="BRNSMALR", f="RROCK03" }
  TECH_PIC2 = { t="CEMENT7",  f="RROCK03" }

  TECH_COMP = { t="COMPSTA2", f="RROCK03" }

  LOGO_1 = { t="PANEL6", f="RROCK03" }


  -- switches --

  SW1CMT = { t="SW1CMT", f="DEM1_2" }


  -- floors --

  GRASS1 = { t="MARBGRAY", f="TLITE6_1" }
  GRASS2 = { t="MARBGRAY", f="CONS1_7" }

  GRAY_BRICK = { f="GRASS2", t="STARTAN3" }
  HERRING_1  = { f="FLAT9", t="HW306" }
  WOOD_TILE  = { f="CEIL5_2", t="MIDBARS1", }

--FLAT14   = { t="STARTAN3", f="FLAT14" }


  -- rails --

  CABLE   = { t="HW167",    rail_h=48 }
  SHARKS  = { t="FIREWALB", rail_h=128 }
  SHELVES = { t="TEKGREN1", rail_h=128 }
  GRILL   = { t="TEKGREN2", rail_h=128 }
  WEB     = { t="HW213",    rail_h=34 }

  CAGE3     = { t="SPACEW3", rail_h=128 }
  CAGE4     = { t="SPACEW4", rail_h=128 }
  CAGE_BUST = { t="HW181",   rail_h=128 }

  FORCE_FIELD = { t="SLADRIP1", rail_h=128 }
  HIGH_BARS   = { t="HW203",    rail_h=128 }
  BRIDGE_RAIL = { t="HW211",    rail_h=128 }
  SUPT_BEAM   = { t="SHAWN2",   rail_h=128 }
  BARRACADE   = { t="HW225",    rail_h=128 }

  DARK_CONC_HOLE = { t="HW204", rail_h=128 }
  GRAY_ROCK_HOLE = { t="HW183", rail_h=128 }
  WASHGTON_HOLE  = { t="HW353", rail_h=128 }


  -- liquids / animated --

  L_ELEC   = { f="NUKAGE1", t="HW177" }
  L_GOO    = { f="LAVA1",   t="HW325" }
  L_WATER  = { f="FWATER1", t="BLODRIP1" }
  L_WATER2 = { f="SLIME05", t="WFALL1" }
  L_LAVA   = { f="SLIME09", t="SFALL1" }
  L_SLIME  = { f="SLIME01", t="BRICK6" }

  TELEPORT = { f="BLOOD1",  t="BRONZE1" }


  -- other --

  O_PILL   = { t="HW313", f="O_PILL",   sane=1 }
  O_BOLT   = { t="HW316", f="O_BOLT",   sane=1 }
  O_RELIEF = { t="HW329", f="O_RELIEF", sane=1 }
  O_CARVE  = { t="HW309", f="O_CARVE",  sane=1 }
}


HACX.LIQUIDS =
{
  water  = { mat="L_WATER",  light=168, special=0 }
  water2 = { mat="L_WATER2", light=168, special=0 }

  slime  = { mat="L_SLIME",  light=168, special=16, damage=20 }
  goo    = { mat="L_GOO",    light=168, special=16, damage=20 }
  lava   = { mat="L_LAVA",   light=192, special=16, damage=20 }
  elec   = { mat="L_ELEC",   light=176, special=16, damage=20 }
}


----------------------------------------------------------------

HACX.SKINS =
{
  ----| STARTS |----

  Start_basic =
  {
    _prefab = "START_SPOT"
    _where  = "middle"

    top = "O_BOLT"
  }


  ----| EXITS |----

  Exit_switch =
  {
    _prefab = "EXIT_PILLAR",
    _where  = "middle"

    switch = "BROWNHUG"
    exit = "METAL"
    exitside = "METAL"
    special = 11
    tag = 0
  }


  ----| STAIRS |----

  Stair_Up1 =
  {
    _prefab = "STAIR_6"
    _where  = "floor"
    _deltas = { 32,48,48,64,64,80 }
  }

  Stair_Down1 =
  {
    _prefab = "NICHE_STAIR_8"
    _where  = "floor"
    _deltas = { -32,-48,-64,-64,-80,-96 }
  }

  Lift_Up1 =
  {
    _prefab = "LIFT_UP"
    _where  = "floor"
    _tags   = 1
    _deltas = { 96,128,160,192 }

    lift = "LIFT"
     top = "LIFT"

    walk_kind   = 88
    switch_kind = 62
  }

  Lift_Down1 =
  {
    _prefab = "LIFT_DOWN"
    _where  = "floor"
    _tags   = 1
    _deltas = { -96,-128,-160,-192 }

    lift = "LIFT"
     top = "LIFT"

    walk_kind   = 88
    switch_kind = 62
  }



  ---| LOCKED DOORS |---

  Locked_kz_blue =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _key    = "kz_blue"
    _long   = 192
    _deep   = 32

    w = 128
    h = 112
    door_h = 112
    door = "HD6"
    key = "HW512"
    track = "DOORTRAK"

    special = 32
    tag = 0  -- kind_mult=26
  }

  Locked_kz_yellow =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _key    = "kz_yellow"
    _long   = 192
    _deep   = 32

    w = 128
    h = 112

    door_h = 112
    door = "HD6"
    key = "HW511"
    track = "DOORTRAK"

    special = 34
    tag = 0  -- kind_mult=27
  }

  Locked_kz_red =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _key    = "kz_red"
    _long   = 192
    _deep   = 32

    w = 128
    h = 112

    door_h = 112
    door = "HD6"
    key = "HW510"
    track = "DOORTRAK"

    special = 33
    tag = 0  -- kind_mult=28
  }


  ---| SWITCHED DOORS |---

  Door_SW_blue =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _switch = "sw_blue"
    _long = 192
    _deep = 32

    w = 128
    h = 112

    door = "LITE2"
    track = "DOORTRAK"

    door_h = 112
    special = 0
  }

  Switch_blue1 =
  {
    _prefab = "SMALL_SWITCH"
    _where  = "middle"
    _switch = "sw_blue"

    switch_h = 64
    switch = "SW1CMT"
    side = "LITE2"
    base = "LITE2"
    x_offset = 0
    y_offset = 50
    special = 103
  }


  ---| TELEPORTERS |---

  Teleporter1 =
  {
    _prefab = "TELEPORT_PAD"
    _where  = "middle"

    tele = "TELEPORT"
    side = "TELEPORT"

    x_offset = 0
    y_offset = 0
    peg = 1

    special = 97
    effect = 8
    light = 255
  }


  ---| PICTURES |---

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

  Pic_Neon =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "O_NEON"
    pic_w = 128
    pic_h = 128

    light = 64
    effect = 8
    fx_delta = -64
  }


  Pic_Techy =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = { TECH_PIC1 = 50, TECH_PIC2 = 50, LOGO_1 = 50 }
    pic_w = 128
    pic_h = 128

    light = 48
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
  }

  Hall_Basic_I_Lift =
  {
    _prefab = "HALL_BASIC_I_LIFT"
    _shape  = "IL"
    _tags   = 1

    lift = "LIFT"
    top  = "LIFT"

    raise_W1 = 130
    lower_WR = 88  -- 120
    lower_SR = 62  -- 123
  }
}


----------------------------------------------------------------

HACX.THEME_DEFAULTS =
{
  starts = { Start_basic = 50 }

  exits = { Exit_switch = 50 }

  stairs = { Stair_Up1 = 50, Stair_Down1 = 50,
              Lift_Up1 = 10,  Lift_Down1 = 10 }

  keys = { kz_red=50, kz_blue=50, kz_yellow=50 }

  logos = { Pic_Carve=50, Pic_Pill=50 }

  pictures = { Pic_Techy=50 }

  switches = { sw_blue = 50 }

  switch_fabs = { Switch_blue1 = 50 }

  locked_doors = { Locked_kz_blue=50, Locked_kz_red=50, Locked_kz_yellow=50,
                   Door_SW_blue = 50 }

  teleporters = { Teleporter1 = 50 }

  hallway_groups = { basic = 50 }

  mini_halls = { Hall_Basic_I = 50 }
}


HACX.NAME_THEMES =
{
}


HACX.HALLWAY_GROUPS =
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


HACX.ROOM_THEMES =
{
  Urban_generic =
  {
    walls =
    {
      MODWALL3=50, STONY1=50, TECHY1=50, CAVEY1=50, BLOCKY1=50, BLOCKY2=50
    }

    floors =
    {
      MODWALL3=50, STONY1=50, TECHY1=50, CAVEY1=50, BLOCKY1=50, WOODY1=50
      WOOD_TILE=50,
    }

    ceilings =
    {
      MODWALL3=50, STONY1=50, TECHY1=50, CAVEY1=50, BLOCKY1=50, WOODY1=50
    }
  }

  Cave_generic =
  {
    naturals = { GRAY_ROCK=50 }
  }

  Outdoors_generic =
  {
    floors = { HERRING_1=50, GRAY_BRICK=50 }

    naturals = { GRAY_ROCK=50, DIRTY1=50, GRASS1=50 }
  }
}


HACX.LEVEL_THEMES =
{
  hacx_urban1 =
  {
    prob = 50

    liquids = { water=90, water2=50, elec=90, lava=50, slime=20, goo=10 }

    buildings = { Urban_generic=50 }

    caves = { Cave_generic=50 }

    outdoors = { Outdoors_generic=50 }

    -- hallways = { blah }

    -- TODO: more stuff
  }

  -- TODO: more themes (e.g. cyberspace)
}


------------------------------------------------------------


HACX.MONSTERS =
{
  thug =
  {
    id = 3004
    r = 21
    h = 72
    level = 1
    prob = 60
    health = 60
    damage = 5
    attack = "hitscan"
  }

  android =
  {
    id = 9
    r = 21
    h = 70
    level = 2
    prob = 50
    health = 75
    damage = 10
    attack = "hitscan"
  }

  stealth =
  {
    id = 58
    r = 32
    h = 68
    level = 1
    prob = 5
    health = 30
    damage = 25
    attack = "melee"
    float = true
    invis = true
    density = 0.25
  }

  -- this thing just blows up on contact
  roam_mine =
  {
    id = 84
    r = 5
    h = 32
    level = 1
    prob = 12
    health = 50
    damage = 5
    attack = "hitscan"
    float = true
    density = 0.5
  }

  phage =
  {
    id = 67
    r = 25
    h = 96
    level = 3
    prob = 40
    health = 150
    damage = 70
    attack = "missile"
  }

  buzzer =
  {
    id = 3002
    r = 25
    h = 68
    level = 3
    prob = 25
    health = 175
    damage = 25
    attack = "melee"
    float = true
  }

  i_c_e =
  {
    id = 3001
    r = 32
    h = 56
    level = 4
    prob = 10
    health = 225
    damage = 7
    attack = "melee"
  }

  d_man =
  {
    id = 3006
    r = 48
    h = 78
    level = 4
    prob = 10
    health = 250
    damage = 7
    attack = "melee"
    float = true
  }

  monstruct =
  {
    id = 65
    r = 35
    h = 88
    level = 5
    prob = 50
    health = 400
    damage = 80
    attack = "missile"
  }

  majong7 =
  {
    id = 71
    r = 31
    h = 56
    level = 5
    prob = 10
    health = 400
    damage = 20
    attack = "missile"
    density = 0.5
    weap_prefs = { launch=0.2 }
  }

  terminatrix =
  {
    id = 3003
    r = 32
    h = 80
    level = 6
    prob = 25
    health = 450
    damage = 40
    attack = "hitscan"
    density = 0.8
  }

  thorn =
  {
    id = 68
    r = 66
    h = 96
    level = 7
    prob = 25
    health = 600
    damage = 70
    attack = "missile"
  }

  mecha =
  {
    id = 69
    r = 24
    h = 96
    level = 8
    prob = 10
    health = 800
    damage = 150
    attack = "missile"
    density = 0.2
  }
}


HACX.WEAPONS =
{
  boot =
  {
    rate = 2.5
    damage = 5
    attack = "melee"
  }

  pistol =
  {
    pref = 5
    rate = 2.0
    damage = 20
    attack = "hitscan"
    ammo = "bullet"
    per = 1
  }

  reznator =
  {
    id = 2005
    level = 1
    pref = 2
    add_prob = 2
    attack = "melee"
    rate = 8.6
    damage = 10
  }

  tazer =
  {
    id = 2001
    level = 1
    pref = 20
    add_prob = 10
    start_prob = 60
    attack = "hitscan"
    rate = 1.2
    damage = 70
    ammo = "shell"
    per = 1
    give = { {ammo="shell",count=8} }
  }

  cyrogun =
  {
    id = 82
    level = 3
    pref = 40
    add_prob = 20
    attack = "hitscan"
    rate = 0.9
    damage = 170
    splash = { 0,30 }
    ammo = "shell"
    per = 2
    give = { {ammo="shell",count=8} }
  }

  fu2 =
  {
    id = 2002
    level = 3
    pref = 40
    add_prob = 35
    attack = "hitscan"
    rate = 8.6
    damage = 10
    ammo = "bullet"
    per = 1
    give = { {ammo="bullet",count=20} }
  }

  zooka =
  {
    id = 2003
    level = 3
    pref = 20
    add_prob = 25
    attack = "missile"
    rate = 1.7
    damage = 80
    splash = { 50,20,5 }
    ammo = "torpedo"
    per = 1
    give = { {ammo="torpedo",count=2} }
  }

  antigun =
  {
    id = 2004
    level = 5
    pref = 50
    add_prob = 13
    attack = "missile"
    rate = 16
    damage = 20
    ammo = "molecule"
    per = 1
    give = { {ammo="molecule",count=40} }
  }

  nuker =
  {
    id = 2006
    level = 7
    pref = 20
    add_prob = 30
    attack = "missile"
    rate = 1.4
    damage = 300
    splash = {60,60,60,60, 60,60,60,60 }
    ammo = "molecule"
    per = 40
    give = { {ammo="molecule",count=40} }
  }
}


HACX.PICKUPS =
{
  -- HEALTH --

  dampener =
  {
    id = 2014
    prob = 20
    cluster = { 4,7 }
    give = { {health=1} }
  }

  microkit =
  {
    id = 2011
    prob = 60
    cluster = { 2,5 }
    give = { {health=10} }
  }

  hypo =
  {
    id = 2012
    prob = 100
    cluster = { 1,3 }
    give = { {health=25} }
  }

  smart_drug =
  {
    id = 2013
    prob = 3
    big_item = true
    give = { {health=150} }
  }

  -- ARMOR --

  inhaler =
  {
    id = 2015
    prob = 10
    armor = true
    cluster = { 4,7 }
    give = { {health=1} }
  }

  kevlar_armor =
  {
    id = 2018
    prob = 5
    armor = true
    big_item = true
    give = { {health=30} }
  }

  super_armor =
  {
    id = 2019
    prob = 2
    armor = true
    big_item = true
    give = { {health=90} }
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
    cluster = { 1,3 }
    give = { {ammo="bullet", count=50} }
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
    cluster = { 1,3 }
    give = { {ammo="shell",count=20} }
  }

  torpedos =
  {
    id = 2010
    prob = 10
    cluster = { 4,7 }
    give = { {ammo="torpedo",count=1} }
  }

  torpedo_box =
  {
    id = 2046
    prob = 40
    cluster = { 1,3 }
    give = { {ammo="torpedo",count=5} }
  }

  molecules =
  {
    id = 2047
    prob = 20
    cluster = { 2,5 }
    give = { {ammo="molecule",count=20} }
  }

  mol_tank =
  {
    id = 17
    prob = 40
    cluster = { 1,2 }
    give = { {ammo="molecule",count=100} }
  }
}


HACX.PLAYER_MODEL =
{
  danny =
  {
    stats   = { health=0 }
    weapons = { pistol=1, boot=1 }
  }
}


------------------------------------------------------------

function HACX.setup()
  -- nothing needed
end


function HACX.get_levels()
  local MAP_NUM = 11

  if OB_CONFIG.length == "single" then MAP_NUM = 1  end
  if OB_CONFIG.length == "few"    then MAP_NUM = 4  end
  if OB_CONFIG.length == "full"   then MAP_NUM = 32 end

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

    if map >= 31 then
      ep_index = 2 ; ep_along = 0.35
    elseif map >= 21 then
      ep_index = 3 ; ep_along = (map - 20) / 10
    elseif map >= 12 then
      ep_index = 2 ; ep_along = (map - 11) / 9
    else
      ep_index = 1 ; ep_along = map / 11
    end

    local EPI = GAME.episodes[ep_index]
    assert(EPI)

    if OB_CONFIG.length == "single" then
      ep_along = rand.pick{ 0.2, 0.3, 0.4, 0.6, 0.8 }
    elseif OB_CONFIG.length == "few" then
      ep_along = map / MAP_NUM
    end


    local LEV =
    {
      episode = EPI

      name  = string.format("MAP%02d", map)
      patch = string.format("CWILV%02d", map-1)

      ep_along = ep_along
    }

    if map == 31 or map == 32 then
      -- secret levels are easy
      LEV.mon_along = 0.35
    elseif OB_CONFIG.length == "single" then
      LEV.mon_along = ep_along
    else
      -- difficulty ramps up over whole wad
      LEV.mon_along = map * 1.2 / math.min(MAP_NUM, 20)
    end

    -- secret levels
    if map == 31 or map == 32 then
      -- FIXME
    end

    table.insert( EPI.levels, LEV)
    table.insert(GAME.levels, LEV)
  end
end


function HACX.make_cool_gfx()
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

  local GOLD = { 0,47,44, 167,166,165,164,163,162,161,160, 225 }

  local SILVER = { 0,246,243,240, 205,202,200,198, 196,195,194,193,192, 4 }


  local colmaps =
  {
    BRONZE_2, GREEN, RED, GOLD, SILVER
  }

  rand.shuffle(colmaps)

  gui.set_colormap(1, colmaps[1])
  gui.set_colormap(2, colmaps[2])
  gui.set_colormap(3, colmaps[3])
  gui.set_colormap(4, colmaps[4])

  -- patches : HW313, HW316, HW329, HW309
  gui.wad_logo_gfx("RW23_1", "p", "PILL",   128,128, 1)
  gui.wad_logo_gfx("RW25_3", "p", "BOLT",   128,128, 2)
  gui.wad_logo_gfx("RW33_2", "p", "RELIEF", 128,128, 3)
  gui.wad_logo_gfx("RW24_1", "p", "CARVE",  128,128, 4)

  -- flats
  gui.wad_logo_gfx("O_PILL",   "f", "PILL",   64,64, 1)
  gui.wad_logo_gfx("O_BOLT",   "f", "BOLT",   64,64, 2)
  gui.wad_logo_gfx("O_RELIEF", "f", "RELIEF", 64,64, 3)
  gui.wad_logo_gfx("O_CARVE",  "f", "CARVE",  64,64, 4)
end


function HACX.all_done()
  HACX.make_cool_gfx()
end


------------------------------------------------------------

UNFINISHED["hacx"] =
{
  label = "HacX 1.2"

  format = "doom"

  tables = { HACX }

  hooks =
  {
    setup      = HACX.setup
    get_levels = HACX.get_levels
    all_done   = HACX.all_done
  }
}


OB_THEMES["hacx_urban"] =
{
  label = "Urban"
  for_games = { hacx=1 }
  name_theme = "URBAN"
  mixed_prob = 50
}

