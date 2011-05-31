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
  player1 = { id=1, kind="other", r=16,h=56 }
  player2 = { id=2, kind="other", r=16,h=56 }
  player3 = { id=3, kind="other", r=16,h=56 }
  player4 = { id=4, kind="other", r=16,h=56 }

  dm_player     = { id=11, kind="other", r=16,h=56 }
  teleport_spot = { id=14, kind="other", r=16,h=56 }

  --- monsters ---
  thug        = { id=3004, kind="monster", r=21,h=72 }
  android     = { id=   9, kind="monster", r=21,h=70 }
  i_c_e       = { id=3001, kind="monster", r=32,h=56 }
  buzzer      = { id=3002, kind="monster", r=25,h=68 }
  terminatrix = { id=3003, kind="monster", r=32,h=80 }
  d_man       = { id=3006, kind="monster", r=48,h=78 }

  stealth     = { id=58,  kind="monster", r=32,h=68 }
  monstruct   = { id=65,  kind="monster", r=35,h=88 }
  phage       = { id=67,  kind="monster", r=25,h=96 }
  thorn       = { id=68,  kind="monster", r=66,h=96 }
  mecha       = { id=69,  kind="monster", r=24,h=96 }
  majong7     = { id=71,  kind="monster", r=31,h=56 }
  roam_mine   = { id=84,  kind="monster", r=5, h=32 }

  --- pickups ---
  k_password = { id=5,  kind="pickup", r=20,h=16, pass=true }
  k_ckey     = { id=6,  kind="pickup", r=20,h=16, pass=true }
  k_keycard  = { id=13, kind="pickup", r=20,h=16, pass=true }

  kz_red     = { id=38, kind="pickup", r=20,h=16, pass=true }
  kz_yellow  = { id=39, kind="pickup", r=20,h=16, pass=true }
  kz_blue    = { id=40, kind="pickup", r=20,h=16, pass=true }

  tazer    = { id=2001, kind="pickup", r=20,h=16, pass=true }
  cyrogun  = { id=  82, kind="pickup", r=20,h=16, pass=true }
  fu2      = { id=2002, kind="pickup", r=20,h=16, pass=true }
  zooka    = { id=2003, kind="pickup", r=20,h=16, pass=true }
  antigun  = { id=2004, kind="pickup", r=20,h=16, pass=true }
  reznator = { id=2005, kind="pickup", r=20,h=16, pass=true }
  nuker    = { id=2006, kind="pickup", r=20,h=16, pass=true }

  dampener   = { id=2014, kind="pickup", r=20,h=16, pass=true }
  microkit   = { id=2011, kind="pickup", r=20,h=16, pass=true }
  hypo       = { id=2012, kind="pickup", r=20,h=16, pass=true }
  smart_drug = { id=2013, kind="pickup", r=20,h=16, pass=true }

  inhaler      = { id=2015, kind="pickup", r=20,h=16, pass=true }
  kevlar_armor = { id=2018, kind="pickup", r=20,h=16, pass=true }
  super_armor  = { id=2019, kind="pickup", r=20,h=16, pass=true }

  bullets     = { id=2007, kind="pickup", r=20,h=16, pass=true }
  bullet_box  = { id=2048, kind="pickup", r=20,h=16, pass=true }
  shells      = { id=2008, kind="pickup", r=20,h=16, pass=true }
  shell_box   = { id=2049, kind="pickup", r=20,h=16, pass=true }
  torpedos    = { id=2010, kind="pickup", r=20,h=16, pass=true }
  torpedo_box = { id=2046, kind="pickup", r=20,h=16, pass=true }
  molecules   = { id=2047, kind="pickup", r=20,h=16, pass=true }
  mol_tank    = { id=  17, kind="pickup", r=20,h=16, pass=true }

  --- scenery ---
  chair      = { id=35,   kind="scenery", r=24,h=40 }

}


HACX.PARAMETERS =
{
  rails = true
  switches = true
  liquids = true
  teleporters = true
  light_brushes = true

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
  _ERROR = { t="HW171", f="DEM1_2" }
  _SKY   = { t="HW171", f="F_SKY1" }

  -- textures --

  BROWNHUG = { t="BROWNHUG", f="BLOOD1" }
  DOORTRAK = { t="DOORTRAK", f="CEIL3_3" }

  HD6   = { t="HD6",   f="CEIL3_3" }
  HW510 = { t="HW510", f="CEIL3_3" }
  HW511 = { t="HW511", f="CEIL3_3" }
  HW512 = { t="HW512", f="CEIL3_3" }
  HW513 = { t="HW513", f="CEIL3_3" }

  LITE2 = { t="LITE2", f="CEIL3_3" }

  MODWALL3 = { t="MODWALL3", f="CEIL3_3" }

  SW1CMT = { t="SW1CMT", f="CEIL3_3" }

  -- flats --

  GRASS1 = { t="MARBGRAY", f="TLITE6_1" }
  GRASS2 = { t="MARBGRAY", f="CONS1_7" }

}


----------------------------------------------------------------

HACX.SKINS =
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

    switch = "BROWNHUG"
    exit = "MOSAIC1"
    exitside = "MOSAIC1"
    special = 11
    tag = 0
  }


  ----| STAIRS |----

  Stair_Up1 =
  {
    _prefab = "STAIR_6"
    _where  = "chunk"
    _stairs = { up=1 }
  }

  Stair_Down1 =
  {
    _prefab = "NICHE_STAIR_8"
    _where  = "chunk"
    _stairs = { down=1 }
  }


  ---| LOCKED DOORS |---

  Locked_kz_blue =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _keys = { kz_blue=1 }
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
    _keys = { kz_yellow=1 }
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
    _keys = { kz_red=1 }
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
    _switches = { Switch_blue1=50 }
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
    _where  = "edge"
    _long   = 192
    _deep   = 48

    switch_h = 64
    switch = "SW1CMT"
    side = "LITE2"
    base = "LITE2"
    x_offset = 0
    y_offset = 50
    special = 103
  }

}


----------------------------------------------------------------

HACX.SUB_THEME_DEFAULTS =
{
  starts = { Start_basic = 50 }

  exits = { Exit_switch = 50 }

  stairs = { Stair_Up1 = 50, Stair_Down1 = 50 }

  keys = { kz_red=50, kz_blue=50, kz_yellow=50 }

  switch_doors = { Door_SW_blue = 50 }

  lock_doors = { Locked_kz_blue=50, Locked_kz_red=50, Locked_kz_yellow=50 }
}


HACX.SUB_THEMES =
{
  hacx_tech1 =
  {
    prob = 50

    building_walls =
    {
      MODWALL3=50,
    }

    building_floors =
    {
      MODWALL3=50,
    }

    building_ceilings =
    {
      MODWALL3=50,
    }

    courtyard_floors =
    {
      GRASS1=20,
    }
  }  -- TECH
}


------------------------------------------------------------

HACX.MONSTERS =
{
  thug =
  {
    level = 1
    prob = 60
    health = 60
    damage = 5
    attack = "hitscan"
  }

  android =
  {
    level = 1
    prob = 50
    health = 75
    damage = 10
    attack = "hitscan"
  }

  stealth =
  {
    level = 1
    prob = 7
    health = 30
    damage = 25
    attack = "melee"
    float = true
    invis = true
  }

  -- this thing just blows up on contact
  roam_mine =
  {
    level = 1
    prob = 15
    health = 50
    damage = 5
    attack = "hitscan"
    float = true
  }

  phage =
  {
    level = 3
    prob = 40
    health = 150
    damage = 70
    attack = "missile"
  }

  buzzer =
  {
    level = 3
    prob = 40
    health = 175
    damage = 25
    attack = "melee"
    float = true
  }

  i_c_e =
  {
    level = 4
    prob = 10
    health = 225
    damage = 7
    attack = "melee"
  }

  d_man =
  {
    level = 4
    prob = 10
    health = 250
    damage = 7
    attack = "melee"
    float = true
  }

  monstruct =
  {
    level = 5
    prob = 50
    health = 400
    damage = 80
    attack = "missile"
  }

  majong7 =
  {
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
    level = 6
    prob = 25
    health = 450
    damage = 40
    attack = "hitscan"
    density = 0.8
  }

  thorn =
  {
    level = 7
    prob = 25
    health = 600
    damage = 70
    attack = "missile"
  }

  mecha =
  {
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
    pref = 2
    add_prob = 2
    start_prob = 2
    attack = "melee"
    rate = 8.6
    damage = 10
  }

  tazer =
  {
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
    pref = 40
    add_prob = 20
    start_prob = 10
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
    pref = 40
    add_prob = 35
    start_prob = 40
    attack = "hitscan"
    rate = 8.6
    damage = 10
    ammo = "bullet"
    per = 1
    give = { {ammo="bullet",count=20} }
  }

  zooka =
  {
    pref = 20
    add_prob = 25
    start_prob = 10
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
    pref = 50
    add_prob = 13
    start_prob = 5
    attack = "missile"
    rate = 16
    damage = 20
    ammo = "molecule"
    per = 1
    give = { {ammo="molecule",count=40} }
  }

  nuker =
  {
    pref = 20
    add_prob = 30
    start_prob = 0.2
    rarity = 3
    attack = "missile"
    rate = 1.4
    damage = 300
    splash = {60,45,30,30,20,10}
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
    prob = 20
    cluster = { 4,7 }
    give = { {health=1} }
  }

  microkit =
  {
    prob = 60
    cluster = { 2,5 }
    give = { {health=10} }
  }

  hypo =
  {
    prob = 100
    cluster = { 1,3 }
    give = { {health=25} }
  }

  smart_drug =
  {
    prob = 3
    big_item = true
    give = { {health=150} }
  }

  -- ARMOR --

  inhaler =
  {
    prob = 10
    armor = true
    cluster = { 4,7 }
    give = { {health=1} }
  }

  kevlar_armor =
  {
    prob = 5
    armor = true
    big_item = true
    give = { {health=30} }
  }

  super_armor =
  {
    prob = 2
    armor = true
    big_item = true
    give = { {health=90} }
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
    cluster = { 1,3 }
    give = { {ammo="bullet", count=50} }
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
    cluster = { 1,3 }
    give = { {ammo="shell",count=20} }
  }

  torpedos =
  {
    prob = 10
    cluster = { 4,7 }
    give = { {ammo="torpedo",count=1} }
  }

  torpedo_box =
  {
    prob = 40
    cluster = { 1,3 }
    give = { {ammo="torpedo",count=5} }
  }

  molecules =
  {
    prob = 20
    cluster = { 2,5 }
    give = { {ammo="molecule",count=20} }
  }

  mol_tank =
  {
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

  for map = 1,MAP_NUM do
    -- determine episode from map number
    local episode
    local ep_along

    if map >= 31 then
      episode = 2 ; ep_along = 0.35
    elseif map >= 21 then
      episode = 3 ; ep_along = (map - 20) / 10
    elseif map >= 12 then
      episode = 2 ; ep_along = (map - 11) / 9
    else
      episode = 1 ; ep_along = map / 11
    end

    if OB_CONFIG.length == "single" then
      ep_along = rand.pick{ 0.2, 0.3, 0.4, 0.6, 0.8 }
    elseif OB_CONFIG.length == "few" then
      ep_along = map / MAP_NUM
    end


    local LEV =
    {
      name  = string.format("MAP%02d", map)
      patch = string.format("CWILV%02d", map-1)

      map      = map
      episode  = episode
      ep_along = ep_along
    }

    LEV.mon_along = LEV.ep_along

    if OB_CONFIG.length == "episode" then
      LEV.mon_along = map / 9
    elseif OB_CONFIG.length == "full" then
      LEV.mon_along = map / 16
    end

    -- secret levels
    if map == 31 or map == 32 then
      -- FIXME
    end

    table.insert(GAME.levels, LEV)
  end
end


------------------------------------------------------------

OB_GAMES["hacx"] =
{
  label = "HacX 1.2"

  format = "doom"

  tables = { HACX }

  hooks =
  {
    setup      = HACX.setup
    get_levels = HACX.get_levels
  }
}


OB_THEMES["hacx_tech"] =
{
  label = "Tech"
  for_games = { hacx=1 }
  name_theme = "TECH"
  mixed_prob = 50
}

