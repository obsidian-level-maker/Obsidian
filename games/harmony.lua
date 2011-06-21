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
  player1 = { id=1, kind="other", r=16,h=56 }
  player2 = { id=2, kind="other", r=16,h=56 }
  player3 = { id=3, kind="other", r=16,h=56 }
  player4 = { id=4, kind="other", r=16,h=56 }

  dm_player     = { id=11, kind="other", r=16,h=56 }
  teleport_spot = { id=14, kind="other", r=16,h=56 }
  
  --- monsters ---
  beastling   = { id=3004, kind="monster", r=20,h=56 }
  follower    = { id=9,    kind="monster", r=20,h=56 }
  critter     = { id=3003, kind="monster", r=24,h=24 }
  centaur     = { id=16,   kind="monster", r=40,h=112 }

  mutant    = { id=65,  kind="monster", r=20,h=56 }
  phage     = { id=68,  kind="monster", r=48,h=64 }
  predator  = { id=66,  kind="monster", r=20,h=56 }
  falling   = { id=64,  kind="monster", r=20,h=56 }
  echidna   = { id=7,   kind="monster", r=128,h=112 }

  --- keys ---
  kc_green   = { id=5,  kind="pickup", r=20,h=16, pass=true }
  kc_yellow  = { id=6,  kind="pickup", r=20,h=16, pass=true }
  kc_purple  = { id=13, kind="pickup", r=20,h=16, pass=true }

  kn_purple  = { id=38, kind="pickup", r=20,h=16, pass=true }
  kn_yellow  = { id=39, kind="pickup", r=20,h=16, pass=true }
  kn_blue    = { id=40, kind="pickup", r=20,h=16, pass=true }

  --- weapons ---
  shotgun    = { id=2001, kind="pickup", r=20,h=16, pass=true }
  minigun    = { id=2002, kind="pickup", r=20,h=16, pass=true }
  launcher   = { id=2003, kind="pickup", r=20,h=16, pass=true }
  entropy    = { id=2004, kind="pickup", r=20,h=16, pass=true }
  h_grenade  = { id=2006, kind="pickup", r=20,h=30, pass=true }

  --- ammo ---
  mini_box   = { id=2048, kind="pickup", r=20,h=16, pass=true }
  shell_box  = { id=2049, kind="pickup", r=20,h=16, pass=true }
  cell_pack  = { id=  17, kind="pickup", r=20,h=16, pass=true }
  grenade    = { id=2010, kind="pickup", r=20,h=16, pass=true }
  nade_belt  = { id=2046, kind="pickup", r=20,h=16, pass=true }

  --- health ---
  mushroom     = { id=2011, kind="pickup", r=20,h=16, pass=true }
  first_aid    = { id=2012, kind="pickup", r=20,h=16, pass=true }
  amazon_armor = { id=2018, kind="pickup", r=20,h=16, pass=true }
  ndf_armor    = { id=2019, kind="pickup", r=20,h=16, pass=true }

  --- powerup ---
  mushroom_wow = { id=2013, kind="pickup", r=20,h=16, pass=true }
  computer_map = { id=2026, kind="pickup", r=20,h=16, pass=true }

  --- scenery ---

  -- TODO: SIZES and PASSIBILITY

  bridge = { id=118, kind="scenery",  r=20,h=16 }
  barrel = { id=2035, kind="scenery", r=20,h=56 }
  flames = { id=36, kind="scenery",   r=20,h=56 }
  amira  = { id=32, kind="scenery",   r=20,h=56 }

  solid_shroom = { id=30, kind="scenery", r=20,h=56 }
  truck_pipe   = { id=31, kind="scenery", r=20,h=56 }
  sculpture    = { id=33, kind="scenery", r=20,h=56 }
  dead_tree    = { id=54, kind="scenery", r=20,h=56 }
  water_drip   = { id=42, kind="scenery", r=20,h=56 }
  dope_fish    = { id=45, kind="scenery", r=20,h=56 }

  tall_lamp  = { id=48, kind="scenery", r=20,h=56 }
  laser_lamp = { id=2028, kind="scenery", r=20,h=56 }
  candle     = { id=34, kind="scenery", r=20,h=56 }
  fire       = { id=55, kind="scenery", r=20,h=56 }
  fire_box   = { id=57, kind="scenery", r=20,h=56 }

  flies       = { id=2007, kind="scenery", r=20,h=56, pass=true }
  nuke_splash = { id=46, kind="scenery", r=20,h=56 }
  ceil_sparks = { id=56, kind="scenery", r=20,h=56 }
  brazier     = { id=63, kind="scenery", r=20,h=56, ceil=true }
  missile     = { id=27, kind="scenery", r=20,h=56 }

  vine_thang   = { id=28, kind="scenery", r=20,h=56 }
  skeleton     = { id=19, kind="scenery", r=20,h=56 }
  hang_chains  = { id=73, kind="scenery", r=20,h=56 }
  minigun_rack = { id=74, kind="scenery", r=20,h=88 }
  shotgun_rack = { id=75, kind="scenery", r=20,h=64 }

  dead_amazon = { id=15, kind="scenery", r=20,h=16, pass=true }
  dead_beast  = { id=21, kind="scenery", r=20,h=16, pass=true }
}


HARMONY.PARAMETERS =
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

HARMONY.MATERIALS =
{
  -- FIXME!!! very incomplete

  -- special materials --

  _ERROR = { t="METAL3", f="DEM1_6" }
  _SKY   = { t="METAL3", f="F_SKY1" }


  -- general purpose --

  METAL  = { t="METAL3",   f="DEM1_6" }

  DOORTRAK = { t="DOORTRAK", f="CEIL5_1" }


  -- walls --

  ORANJE3 = { t="0ORANJE3", f="FLOOR0_3" }


  -- floors --

  FLOOR4_8 = { f="FLOOR4_8", t="SILVER3" }

  GRASS2 = { t="ZZWOLF11", f="GRASS2" }



  -- switches --


  -- liquids --

  WATER   = { t="SFALL1",   f="FWATER1" }
  W_ICE   = { t="SFALL1",   f="NUKAGE1" }
  W_ROCK  = { t="SFALL1",   f="SLIME05" }
  W_STEEL = { t="GSTFONT1", f="BLOOD1"  }

  LAVA    = { t="0ROOD02", f="SLIME01" }  -- NOTE: texture not animated
  NUKAGE  = { f="BFALL1",  f="SLIME09" }


  -- other --

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

    top = "O_BOLT"
  }


  ----| EXITS |----

  Exit_switch =
  {
    _prefab = "EXIT_PILLAR",

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
    _where  = "chunk"
    _deltas = { 32,48,48,64,64,80 }
  }

  Stair_Down1 =
  {
    _prefab = "NICHE_STAIR_8"
    _where  = "chunk"
    _deltas = { -32,-48,-64,-64,-80,-96 }
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

HARMONY.THEME_DEFAULTS =
{
  starts = { Start_basic = 50 }

  exits = { Exit_switch = 50 }

  stairs = { Stair_Up1 = 50, Stair_Down1 = 50 }

--!!  keys = { kz_red=50, kz_blue=50, kz_yellow=50 }

--!!  switch_doors = { Door_SW_blue = 50 }

--!!  lock_doors = { Locked_kz_blue=50, Locked_kz_red=50, Locked_kz_yellow=50 }

  liquids = { water=90, nukage=30, lava=10 }
}


HARMONY.LEVEL_THEMES =
{
  harm_tech1 =
  {
    prob = 50

    building_walls =
    {
      ORANJE3=50,
    }

    building_floors =
    {
      ORANJE3=50,
    }

    building_ceilings =
    {
      FLOOR4_8=50,
    }

    courtyard_floors =
    {
      GRASS2=50,
    }

    landscape_walls =
    {
      GRASS2=50,
    }
  }
}


------------------------------------------------------------

HARMONY.MONSTERS =  --- FIXME !!!! these are HacX
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
    level = 2
    prob = 50
    health = 75
    damage = 10
    attack = "hitscan"
  }

  stealth =
  {
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
    level = 3
    prob = 40
    health = 150
    damage = 70
    attack = "missile"
  }

  buzzer =
  {
    level = 3
    prob = 25
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


HARMONY.WEAPONS =  --- FIXME !!!! these are HacX
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


HARMONY.PICKUPS =  --- FIXME !!!! these are HacX
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


HARMONY.PLAYER_MODEL =
{
  harmony =
  {
    stats   = { health=0 }
    weapons = { pistol=1 }
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

OB_GAMES["harmony"] =
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

