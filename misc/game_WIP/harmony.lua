----------------------------------------------------------------
--  GAME DEF : Harmony 1.1
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2011 Andrew Apted
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

HARMONY = { }

HARMONY.ENTITIES =
{
  --- special stuff ---
  player1 = { id=1, r=16, h=56 }
  player2 = { id=2, r=16, h=56 }
  player3 = { id=3, r=16, h=56 }
  player4 = { id=4, r=16, h=56 }

  dm_player     = { id=11 }
  teleport_spot = { id=14 }
  
  --- keys ---
  kc_green   = { id=5 }
  kc_yellow  = { id=6 }
  kc_purple  = { id=13 }

  kn_purple  = { id=38 }
  kn_yellow  = { id=39 }
  kn_green   = { id=40 }

  --- powerup ---
  computer_map = { id=2026 }

  --- scenery ---

  -- TODO: SIZES and PASSIBILITY

  bridge = { id=118, r=20, h=16 }
  barrel = { id=2035, r=20, h=56 }
  flames = { id=36, r=20, h=56 }
  amira  = { id=32, r=20, h=56 }

  solid_shroom = { id=30, r=20, h=56 }
  truck_pipe   = { id=31, r=20, h=56 }
  sculpture    = { id=33, r=20, h=56 }
  dead_tree    = { id=54, r=20, h=56 }
  water_drip   = { id=42, r=20, h=56 }
  dope_fish    = { id=45, r=20, h=56 }

  tall_lamp  = { id=48, r=20, h=56 }
  laser_lamp = { id=2028, r=20, h=56 }
  candle     = { id=34, r=20, h=56 }
  fire       = { id=55, r=20, h=56 }
  fire_box   = { id=57, r=20, h=56 }

  flies       = { id=2007, r=20, h=56, pass=true }
  nuke_splash = { id=46, r=20, h=56 }
  ceil_sparks = { id=56, r=20, h=56 }
  brazier     = { id=63, r=20, h=56, ceil=true }
  missile     = { id=27, r=20, h=56 }

  vine_thang   = { id=28, r=20, h=56 }
  skeleton     = { id=19, r=20, h=56 }
  hang_chains  = { id=73, r=20, h=56 }
  minigun_rack = { id=74, r=20, h=88 }
  shotgun_rack = { id=75, r=20, h=64 }

  dead_amazon = { id=15, r=20, h=16, pass=true }
  dead_beast  = { id=21, r=20, h=16, pass=true }
}


HARMONY.PARAMETERS =
{
  rails = true
  switches = true
  light_brushes = true

  jump_height = 24

  max_name_length = 28

  skip_monsters = { 10,30 }

  time_factor   = 1.0
  damage_factor = 1.0
  ammo_factor   = 0.8
  health_factor = 0.7
  monster_factor = 0.75
}


----------------------------------------------------------------

HARMONY.MATERIALS =
{
  -- FIXME!!! very incomplete

  -- special materials --

  _ERROR = { t="METAL3", f="DEM1_6" }
  _SKY   = { t="METAL3", f="F_SKY1" }


  -- general purpose --

  METAL  = { t="METAL3",   f="DEM1_6" }

  DOORTRAK = { t="DOORTRAK", f="CEIL5_1" }

  LIFT  = { t="1LIFT2", f="STEP2" }

  YELLOWLITE = { t="PANBORD2", f="FLOOR4_8" }


  -- walls --

  ORANJE3 = { t="0ORANJE3", f="FLOOR0_3" }
  STOEL4  = { t="1STOEL4",  f="RROCK13" }

  LOGO_1 = { t="0IMP", f="FLOOR4_8" }

  BIGDOOR3 = { t="BIGDOOR3", f="FLOOR4_8" }
  BIGDOOR4 = { t="BIGDOOR4", f="FLOOR4_8" }

  GREENWALL = { t="1GREEN", f="FLOOR4_1" }
  PURPLE_UGH = { t="SP_DUDE8", f="DEM1_5" }

  GRAY1 = { t="ZZWOLF7", f="FLAT5_4" }


  -- floors --

  DIRT  = { f="MFLR8_2", t="STONE6" }

  FLOOR4_8 = { f="FLOOR4_8", t="SILVER3" }

  GRASS2 = { f="GRASS2", t="ZZWOLF11" }

  ROCKS = { f="TLITE6_4", t="ZZWOLF9" }


  -- switches --

  SW2COMM = { t="SW2COMM", f="FLOOR4_8" }

  SW2SLAD = { t="SW2SLAD", f="FLOOR4_1" }

  EXITSIGN = { t="EXITSIGN", f="DEM1_5" }


  -- rails --

  LADDER       = { t="0LADDER",  rail_h=128 }
  LASER_BEAM   = { t="0LASER4",  rail_h=8 }
  ELECTRICITY  = { t="ROCKRED1", rail_h=48 }

  RED_WIRING   = { t="MODWALL1", rail_h=128 }
  BLUE_WIRING  = { t="CEMENT7",  rail_h=128 }
  FANCY_WINDOW = { t="ZELDOOR", rail_h=128 }

  GRATE_HOLE   = { t="STUCCO3", rail_h=64 }
  RUSTY_GRATE  = { t="MIDGRATE", rail_h=128 }
  METAL_BAR1   = { t="0MBAR1",  rail_h=16 }
  METAL_BAR2   = { t="0MBAR2",  rail_h=64 }

  R_LIFT1   = { t="1LIFT1", rail_h=128 }
  R_LIFT3   = { t="1LIFT3", rail_h=128 }
  R_LIFT4   = { t="1LIFT4", rail_h=128 }
  R_PRED    = { t="0PRED",  rail_h=128 }

  BAR_MUSIC = { t="SP_DUDE7", rail_h=128 }
  NO_WAR    = { t="0GRAFFI",  rail_h=128 }
  LAST_DOPE = { t="0DOPE",    rail_h=64  }
  THE_END   = { t="0END2",    rail_h=128 }

  BIG_BRIDGE_L = { t="SKINMET2", rail_h=128 }
  BIG_BRIDGE_R = { t="SKINSCAB", rail_h=128 }

  GLASS       = { t="SLOPPY1", rail_h=128 }
  GLASS_SMASH = { t="SLOPPY2", rail_h=128 }
  GLASS_BLUE  = { t="0BLUEGL", rail_h=128 }

  BLUE_PEAK   = { t="0ARK1", rail_h=128 }
  METAL_ARCH  = { t="0ARCH", rail_h=128 }

  STONE_ARCH   = { t="ZZWOLF3",  rail_h=64 }
  STONE_PEAK   = { t="0DRIEHK1", rail_h=32 }
  STONE_CURVE1 = { t="0CURVE1",  rail_h=128 }
  STONE_CURVE2 = { t="0CURVE2",  rail_h=128 }

  IRIS_DOOR1  = { t="0IRIS1", rail_h=128 }
  IRIS_DOOR2  = { t="0IRIS2", rail_h=128 }
  IRIS_DOOR3  = { t="0IRIS3", rail_h=128 }
  IRIS_DOOR4  = { t="0IRIS4", rail_h=128 }
  IRIS_FRAME1 = { t="0IRIS5", rail_h=128 }
  IRIS_FRAME2 = { t="0IRIS7", rail_h=128 }


  -- liquids --

  WATER   = { f="FWATER1", t="SFALL1"   }
  W_ICE   = { f="NUKAGE1", t="SFALL1"   }
  W_ROCK  = { f="SLIME05", t="SFALL1"   }
  W_STEEL = { f="BLOOD1",  t="GSTFONT1" }
                          
  LAVA    = { f="SLIME01", t="0ROOD02"  }  -- NOTE: texture not animated
  NUKAGE  = { f="SLIME09", t="BFALL1"   }

  TELEPORT = { f="FLOOR5_3", t="PANEL8" }

  -- other --

--FIXME:
--  O_PILL   = { t="HW313", f="O_PILL",   sane=1 }
--  O_BOLT   = { t="HW316", f="O_BOLT",   sane=1 }
--  O_RELIEF = { t="HW329", f="O_RELIEF", sane=1 }
--  O_CARVE  = { t="HW309", f="O_CARVE",  sane=1 }
}


HARMONY.RAILS =
{
  -- TODO
}


HARMONY.LIQUIDS =
{
  water   = { mat="WATER",   light=0.50, special=0 }
  w_steel = { mat="W_STEEL", light=0.50, special=0 }
  w_rock  = { mat="W_ROCK",  light=0.50, special=0 }
  w_ice   = { mat="W_ICE",   light=0.50, special=0 }

  lava    = { mat="LAVA",    light=0.75, special=16 }
  nukage  = { mat="NUKAGE",  light=0.65, special=16 }
}


----------------------------------------------------------------

HARMONY.SKINS =
{
  ----| STARTS |----

  Start_basic =
  {
    _prefab = "START_SPOT"
    _where  = "middle"

    top = "O_BOLT"
  }


  ----| EXITS |----

  Exit_pillar =
  {
    _prefab = "EXIT_PILLAR",
    _where  = "middle"

    switch = "SW2SLAD"
    exit = "EXITSIGN"
    exitside = "PURPLE_UGH"

    use_sign = 1
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


  ---| LOCKED DOORS |---

  Locked_green =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _key    = "kc_green"
    _long   = 192
    _deep   = 32

    w = 128
    h = 112
    door_h = 112
    door = "BIGDOOR4"
    key = "GREENWALL"
    track = "DOORTRAK"

    special = 32
    tag = 0
  }

  Locked_yellow =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _key    = "kc_yellow"
    _long   = 192
    _deep   = 32

    w = 128
    h = 112

    door_h = 112
    door = "BIGDOOR4"
    key = "YELLOWLITE"
    track = "DOORTRAK"

    special = 34
    tag = 0
  }

  Locked_purple =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _key    = "kc_purple"
    _long   = 192
    _deep   = 32

    w = 128
    h = 112

    door_h = 112
    door = "BIGDOOR4"
    key = "PURPLE_UGH"
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

    door = "BIGDOOR3"
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
    switch = "SW2COMM"
    side = "METAL"
    base = "METAL"
    x_offset = 0
    y_offset = 0
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

  Pic_Logo =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "LOGO_1"
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

HARMONY.THEME_DEFAULTS =
{
  starts = { Start_basic = 50 }

  exits = { Exit_pillar = 50 }

  stairs = { Stair_Up1 = 50, Stair_Down1 = 50 }

  logos = { Pic_Logo = 50 }

  keys = { kc_green=50, kc_purple=50, kc_yellow=50 }

  switches = { sw_blue=50 }

  switch_fabs = { Switch_blue1 = 50 }

  locked_doors = { Locked_green=50, Locked_purple=50, Locked_yellow=50,
                   Door_SW_blue = 50 }

  teleporters = { Teleporter1 = 50 }

  hallway_groups = { basic = 50 }

  mini_halls = { Hall_Basic_I = 50 }
}


HARMONY.HALLWAY_GROUPS =
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


HARMONY.ROOM_THEMES =
{
  Tech_generic =
  {
    facades =
    {
      STOEL4 = 50
    }

    walls =
    {
      ORANJE3 = 50
    }

    floors =
    {
      ORANJE3 = 50
    }

    ceilings =
    {
      FLOOR4_8 = 50
    }
  }


  Hallway_generic =
  {
    walls =
    {
      GRAY1 = 50
    }
  }


  Cave_generic =
  {
    naturals =
    {
      ROCKS = 50
    }
  }


  Outdoors_generic =
  {
    floors =
    {
      DIRT = 50
      GRASS2 = 15
    }

    naturals =
    {
      GRASS2 = 50
      ROCKS = 10
    }
  }
}


HARMONY.LEVEL_THEMES =
{
  harm_tech1 =
  {
    prob = 50

    liquids = { water=90, nukage=30, lava=10 }

    buildings = { Tech_generic=50 }

    hallways = { Hallway_generic=50 }

    caves = { Cave_generic=50 }

    outdoors = { Outdoors_generic=50 }
  }
}


------------------------------------------------------------

HARMONY.MONSTERS =
{
  -- FIXME: heaps of guesswork here

  -- FIXME: falling = { id=64, r=20, h=56 }

  beastling =
  {
    id = 3004
    r = 20
    h = 56
    level = 1
    prob = 35
    health = 150
    attack = "melee"
    damage = 25
  }

  critter =
  {
    id = 3003
    r = 24
    h = 24
    level = 4
    prob = 15
    health = 100
    attack = "melee"
    damage = 15
  }

  follower =
  {
    id = 9
    r = 20
    h = 56
    level = 1
    prob = 50
    health = 30
    attack = "hitscan"
    damage = 10
--??  give = { {weapon="shotgun"}, {ammo="shell",count=4} }
  }

  predator =
  {
    id = 66
    r = 20
    h = 56
    level = 2
    prob = 60
    health = 60
    attack = "missile"
    damage = 20
  }

  centaur =
  {
    id = 16
    r = 40
    h = 112
    level = 5
    prob = 60
    skip_prob = 90
    crazy_prob = 40
    health = 500
    attack = "missile"
    damage = 45
    density = 0.7
  }

  mutant =
  {
    id = 65
    r = 20
    h = 56
    level = 3
    prob = 20
    health = 70
    attack = "hitscan"
    damage = 50
--??  give = { {weapon="minigun"}, {ammo="bullet",count=10} }
  }

  phage =
  {
    id = 68
    r = 48
    h = 64
    level = 6
    prob = 25
    health = 500
    attack = "missile"
    damage = 70
    density = 0.8
  }


  --- BOSS ---

  echidna =
  {
    id = 7
    r = 128
    h = 112
    level = 9
    prob = 20
    crazy_prob = 18
    skip_prob = 150
    health = 3000
    attack = "hitscan"
    damage = 70
    density = 0.2
  }
}


HARMONY.WEAPONS =
{
  -- FIXME: most of these need to be checked, get new firing rates (etc etc)

  blow_uppa_ya_face =
  {
    attack = "missile"
    rate = 0.7
    damage = 20
  }

  pistol =
  {
    pref = 5
    attack = "missile"
    rate = 2.0
    damage = 20
    ammo = "cell"
    per = 1
  }

  minigun =
  {
    id = 2002
    add_prob = 35
    start_prob = 40
    pref = 70
    attack = "hitscan"
    rate = 8.5
    damage = 10
    ammo = "bullet"
    per = 1
    give = { {ammo="bullet",count=20} }
  }

  shotgun =
  {
    id = 2001
    add_prob = 10
    start_prob = 60
    pref = 70
    attack = "hitscan"
    rate = 0.9
    damage = 70
    splash = { 0,10 }
    ammo = "shell"
    per = 1
    give = { {ammo="shell",count=8} }
  }

  launcher =
  {
    id = 2003
    add_prob = 25
    start_prob = 15
    pref = 40
    attack = "missile"
    rate = 1.7
    damage = 80
    splash = { 50,20,5 }
    ammo = "grenade"
    per = 1
    give = { {ammo="grenade",count=2} }
  }

  entropy =
  {
    id = 2004
    add_prob = 13
    start_prob = 7
    pref = 25
    rate = 11
    damage = 20
    attack = "missile"
    ammo = "cell"
    per = 1
    give = { {ammo="cell",count=40} }
  }

-- FIXME  h_grenade = { id = 2006 }
}


HARMONY.PICKUPS =
{
  -- HEALTH --

  mushroom =
  {
    id = 2011
    prob = 60
    cluster = { 2,5 }
    give = { {health=10} }
  }

  first_aid =
  {
    id = 2012
    prob = 100
    cluster = { 1,3 }
    give = { {health=25} }
  }

  mushroom_wow =
  {
    id = 2013
    prob = 3
    big_item = true
    give = { {health=150} }
  }

  -- ARMOR --

  amazon_armor =
  {
    id = 2018
    prob = 5
    armor = true
    big_item = true
    give = { {health=30} }
  }

  NDF_armor =
  {
    id = 2019
    prob = 2
    armor = true
    big_item = true
    give = { {health=90} }
  }

  -- AMMO --

  mini_box =
  {
    id = 2048
    prob = 40
    cluster = { 1,3 }
    give = { {ammo="bullet", count=40} }
  }

  shell_box =
  {
    id = 2049
    prob = 40
    cluster = { 1,4 }
    give = { {ammo="shell",count=10} }
  }

  cell_pack =
  {
    id = 17
    prob = 40
    give = { {ammo="cell",count=100} }
  }

  grenade =
  {
    id = 2010
    prob = 20
    cluster = { 2,5 }
    give = { {ammo="grenade",count=1} }
  }

  nade_belt =
  {
    id = 2046
    prob = 40
    cluster = { 1,2 }
    give = { {ammo="grenade",count=5} }
  }
}


HARMONY.PLAYER_MODEL =
{
  harmony =
  {
    stats   = { health=0 }
    weapons = { pistol=1, blow_uppa_ya_face=1 }
  }
}


------------------------------------------------------------

function HARMONY.setup()
  -- nothing needed
end


function HARMONY.get_levels()
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


function HARMONY.make_cool_gfx()
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

--[[ FIXME

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
--]]
end


function HARMONY.all_done()
  HARMONY.make_cool_gfx()
end


------------------------------------------------------------

UNFINISHED["harmony"] =
{
  label = "Harmony"

  format = "doom"

  tables = { HARMONY }

  hooks =
  {
    setup      = HARMONY.setup
    get_levels = HARMONY.get_levels
    all_done   = HARMONY.all_done
  }
}


OB_THEMES["harm_tech"] =
{
  label = "Tech"
  for_games = { harmony=1 }
  name_theme = "TECH"
  mixed_prob = 50
}

