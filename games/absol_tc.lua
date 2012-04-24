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
  player1 = { id=1, kind="other", r=16,h=56 }
  player2 = { id=2, kind="other", r=16,h=56 }
  player3 = { id=3, kind="other", r=16,h=56 }
  player4 = { id=4, kind="other", r=16,h=56 }

  dm_player     = { id=11, kind="other", r=16,h=56 }
  teleport_spot = { id=14, kind="other", r=16,h=56 }
  voodoo_doll   = { id=88, kind="other", r=16,h=56 }

  --- monsters ---
  zombie    = { id=3004,kind="monster", r=20,h=56 }
  shooter   = { id=9,   kind="monster", r=20,h=56 }
  demon     = { id=3002,kind="monster", r=20,h=56 }
  imp       = { id=3001,kind="monster", r=20,h=56 }
  skull     = { id=3006,kind="monster", r=16,h=56 }

  caco      = { id=3005,kind="monster", r=31,h=56 }
  knight    = { id=69,  kind="monster", r=24,h=64 }
  baron     = { id=3003,kind="monster", r=24,h=64 }
  mancubus  = { id=67,  kind="monster", r=48,h=64 }
  arach     = { id=68,  kind="monster", r=66,h=64 }
  pain      = { id=71,  kind="monster", r=31,h=56 }

  nm_demon  = { id=72,  kind="monster", r=32,h=56 }
  nm_imp    = { id=400, kind="monster", r=30,h=56 }
  nm_caco   = { id=66,  kind="monster", r=20,h=56 }

  --- bosses ---
  CyberDemon  = { id=16,   kind="monster", r=40,h=80 }
  MotherDemon = { id=5000, kind="monster", r=20,h=80 }

  --- keys ---
  kc_red     = { id=13, kind="pickup", r=20,h=16, pass=true }
  kc_yellow  = { id=6,  kind="pickup", r=20,h=16, pass=true }
  kc_blue    = { id=5,  kind="pickup", r=20,h=16, pass=true }

  ks_red     = { id=38, kind="pickup", r=20,h=16, pass=true }
  ks_yellow  = { id=39, kind="pickup", r=20,h=16, pass=true }
  ks_blue    = { id=40, kind="pickup", r=20,h=16, pass=true }

  --- weapons ---
  shotty = { id=2001, kind="pickup", r=20,h=16, pass=true }
  super  = { id=  82, kind="pickup", r=20,h=16, pass=true }
  chain  = { id=2002, kind="pickup", r=20,h=16, pass=true }
  launch = { id=2003, kind="pickup", r=20,h=16, pass=true }
  plasma = { id=2004, kind="pickup", r=20,h=16, pass=true }
  saw    = { id=2005, kind="pickup", r=20,h=16, pass=true }
  bfg    = { id=2006, kind="pickup", r=20,h=16, pass=true }
  laser  = { id=2009, kind="pickup", r=20,h=16, pass=true }

  --- ammo ---
  bullets    = { id=2007, kind="pickup", r=20,h=16, pass=true }
  rocket     = { id=2010, kind="pickup", r=20,h=16, pass=true }
  shells     = { id=2008, kind="pickup", r=20,h=16, pass=true }
  cells      = { id=2047, kind="pickup", r=20,h=16, pass=true }

  bullet_box = { id=2048, kind="pickup", r=20,h=16, pass=true }
  shell_box  = { id=2049, kind="pickup", r=20,h=16, pass=true }
  rocket_box = { id=2046, kind="pickup", r=20,h=16, pass=true }
  cell_pack  = { id=  17, kind="pickup", r=20,h=16, pass=true }

  --- health / armor ---
  potion   = { id=2014, kind="pickup", r=20,h=16, pass=true }
  stimpack = { id=2011, kind="pickup", r=20,h=16, pass=true }
  medikit  = { id=2012, kind="pickup", r=20,h=16, pass=true }
  soul     = { id=2013, kind="pickup", r=20,h=16, pass=true }

  helmet      = { id=2015, kind="pickup", r=20,h=16, pass=true }
  green_armor = { id=2018, kind="pickup", r=20,h=16, pass=true }
  blue_armor  = { id=2019, kind="pickup", r=20,h=16, pass=true }
  mega        = { id=  83, kind="pickup", r=20,h=16, pass=true }

  --- powerups ---
  backpack = { id=   8, kind="pickup", r=20,h=16, pass=true }
  invul    = { id=2022, kind="pickup", r=20,h=16, pass=true }
  berserk  = { id=2023, kind="pickup", r=20,h=16, pass=true }
  invis    = { id=2024, kind="pickup", r=20,h=16, pass=true }
  suit     = { id=2025, kind="pickup", r=20,h=60, pass=true }
  map      = { id=2026, kind="pickup", r=20,h=16, pass=true }
  goggles  = { id=2045, kind="pickup", r=20,h=16, pass=true }

  laser_key1 = { id=4000, kind="pickup", r=20,h=16, pass=true }
  laser_key2 = { id=4001, kind="pickup", r=20,h=16, pass=true }
  laser_key3 = { id=4002, kind="pickup", r=20,h=16, pass=true }

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
}


----------------------------------------------------------------

ABSOLUTION.MATERIALS =
{
  -- special materials --

  _ERROR = { t="TILEA796", f="FTILEA79" }
  _SKY   = { t="TILEA796", f="F_SKY1"  }

  -- general purpose --

  -- walls --

  X_WALL = { t="TILEADAC", f="FTILEA79" }


  -- doors --

  TRACK  = { t="TILE7CFA", f="FTILEA79" }
  TRACK2 = { t="TILED839", f="FTILEA79" }

  DOOR1 = { t="TILED4A9", f="FTILEA79" }

  SPLIT_DOOR1 = { t="TILE0CAC", f="FTILEA79" }

  KEY_RED    = { t="TILE7448", f="FTILEA79" }
  KEY_YELLOW = { t="TILE6D7A", f="FTILEA79" }
  KEY_BLUE   = { t="TILE31A4", f="FTILEA79" }

  SW_DOOR = { t="TILE4507", f="FTILEA79" }


  -- switches --


  -- floors --

  X_FLOOR = { f="SPECIAL5", t="TILE1436" }
  X_CEIL  = { f="FTILEC79", t="TILEA796" }


  -- rails --


  -- liquids / animated --

  L_WATER  = { f="FTILE080", t="TILED7C9", sane=1 }
  L_NUKAGE = { f="FTILE2CA", t="TILE0830", sane=1 }
  L_MAGMA  = { f="FTILE0A5", t="TILEB361", sane=1 }
  L_LAVA   = { f="FTILE5A0", t="TILE5A0F", sane=1 }
  L_LAVA2  = { f="FTILE33A", t="TILE33A7", sane=1 }


  -- other --

---  O_PILL   = { t="?", f="O_PILL",  sane=1 }
---  O_BOLT   = { t="?", f="O_BOLT",  sane=1 }
---  O_CARVE  = { t="?", f="O_CARVE", sane=1 }
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


  ----| EXITS |----

  Exit_switch =
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
    track = "TRACK"
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
    door = "SW_DOOR"
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



  ---| BIG JUNCTIONS |---


  ---| TELEPORTERS |---

  Teleporter1 =
  {
    _prefab = "TELEPORT_PAD"
    _where  = "middle"

    tele = "FLTTELE1"
    side = "SQPEB1"

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
  starts = { Start_basic = 50 }

  exits = { Exit_switch = 50 }

  pedestals = { Pedestal_1 = 50 }

  stairs = { Stair_Up1 = 50, Stair_Down1 = 50,
             Lift_Up1 = 2, Lift_Down1 = 2 }

  keys = { kc_red=50, kc_yellow=50, kc_blue=50 }

  switches = { sw_metal=50 }

  switch_fabs = { Switch_1=50 }

  locked_doors = { Locked_yellow=50, Locked_red=50, Locked_blue=50,
                   Door_SW_1=50 }

  teleporters = { Teleporter1=50 }


  steps = { step1=50 }

  doors = { d_wood=50, d_demon=15 }

  logos = { carve=50, pill=50 }

  hallway_groups = { basic = 50 }

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

  Tech_test =
  {
    walls =
    {
      X_WALL=50
    }

    floors =
    {
      X_FLOOR=50
    }

    ceilings =
    {
      X_CEIL=50
    }
  }


  Outdoor_junk =
  {
    floors =
    {
      X_FLOOR=50
    }

    naturals =
    {
      L_MAGMA=20
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

    buildings = { Tech_test=50 }

--    hallways = { Castle_hallway=50 }  -- FIXME

    caves    = { Outdoor_junk=50 }
    outdoors = { Outdoor_junk=50 }

    --TODO: more stuff

  }

}


------------------------------------------------------------

ABSOLUTION.MONSTERS =
{
  -- FIXME: VERIFY ALL THIS STUFF IN THE DEDs !!!

  zombie =
  {
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
    level = 1
    prob = 60
    health = 60
    damage = 20
    attack = "missile"
  }

  nm_imp =
  {
    level = 2
    prob = 10
    health = 60
    damage = 20
    attack = "missile"
    invis = true
    species = "imp"
  }

  skull =
  {
    level = 3
    prob = 16
    health = 100
    damage = 7
    attack = "melee"
    density = 0.5
    float = true
    weap_prefs = { launch=0.2 }
    infights = true
  }

  demon =
  {
    level = 1
    prob = 35
    health = 150
    damage = 25
    attack = "melee"
    weap_prefs = { launch=0.5 }
  }

  nm_demon =
  {
    level = 2
    prob = 10
    health = 150
    damage = 25
    attack = "melee"
    invis = true
    outdoor_factor = 3.0
    weap_prefs = { launch=0.2 }
    species = "demon"
  }

  caco =
  {
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
    level = 4
    prob = 10
    health = 400
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
    level = 6
    prob = 37
    health = 600
    damage = 70
    attack = "missile"
    density = 0.6
  }

  arach =
  {
    level = 6
    prob = 25
    health = 500
    damage = 70
    attack = "missile"
    density = 0.8
  }

  pain =
  {
    level = 6
    prob = 8
    crazy_prob = 15
    skip_prob = 180
    health = 700
    damage = 20
    attack = "missile"
    density = 0.2
    never_promote = true
    float = true
    weap_prefs = { launch=0.2 }
  }


  -- BOSSES --

  -- TODO: CyberDemon
  -- TODO: MotherDemon
}


ABSOLUTION.WEAPONS =
{
  -- FIXME: VERIFY ALL THIS STUFF IN THE DEDs !!!

  fist =
  {
    attack = "melee"
    rate = 1.5
    damage = 10
  }

  saw =
  {
    level = 1
    pref = 3
    add_prob = 2
    attack = "melee"
    rate = 8.7
    damage = 10
  }

  berserk =
  {
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
    prob = 20
    cluster = { 4,7 }
    give = { {health=1} }
  }

  stimpack =
  {
    prob = 60
    cluster = { 2,5 }
    give = { {health=10} }
  }

  medikit =
  {
    prob = 100
    give = { {health=25} }
  }

  soul =
  {
    prob = 3
    big_item = true
    start_prob = 5
    give = { {health=150} }
  }

  -- ARMOR --

  helmet =
  {
    prob = 10
    armor = true
    cluster = { 4,7 }
    give = { {health=1} }
  }

  green_armor =
  {
    prob = 5
    armor = true
    big_item = true
    start_prob = 80
    give = { {health=30} }
  }

  blue_armor =
  {
    prob = 2
    armor = true
    big_item = true
    start_prob = 30
    give = { {health=80} }
  }

  -- AMMO --

  bullets =
  {
    prob = 10
    cluster = { 2,5 }
    give = { {ammo="bullet",count=10} }
  }

  bullet_box =
  {
    prob = 40
    give = { {ammo="bullet",count=50} }
  }

  shells =
  {
    prob = 20
    cluster = { 2,5 }
    give = { {ammo="shell",count=4} }
  }

  shell_box =
  {
    prob = 40
    give = { {ammo="shell",count=20} }
  }

  rocket =
  {
    prob = 10
    cluster = { 4,7 }
    give = { {ammo="rocket",count=1} }
  }

  rocket_box =
  {
    prob = 40
    give = { {ammo="rocket",count=5} }
  }

  cells =
  {
    prob = 20
    cluster = { 2,5 }
    give = { {ammo="cell",count=20} }
  }

  cell_pack =
  {
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
      LEV.mon_along = math.quadratic(map / (MAP_NUM + 1))
    end
  end
end



------------------------------------------------------------

OB_GAMES["absolution"] =
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
  }
}

OB_THEMES["absolution_tech"] =
{
  label = "Tech"
  for_games = { absolution=1 }
  name_theme = "TECH"
  mixed_prob = 50
}

