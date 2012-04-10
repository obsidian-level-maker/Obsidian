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

  --- monsters ---

  --- bosses ---

  --- keys ---
  k_yellow   = { id=80, kind="pickup", r=20,h=16, pass=true }
  k_green    = { id=73, kind="pickup", r=20,h=16, pass=true }
  k_blue     = { id=79, kind="pickup", r=20,h=16, pass=true }

  --- weapons ---

  --- ammo ---

  --- health ---

  --- powerups ---

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

  skip_monsters = { 20,30 }

  time_factor   = 1.0
  damage_factor = 1.0
  ammo_factor   = 0.8
  health_factor = 0.7
}


----------------------------------------------------------------

ABSOLUTION.MATERIALS =
{
  -- special materials --

  _ERROR = { t="WOODWL",  f="FLOOR10" }
  _SKY   = { t="CHAINSD", f="F_SKY1"  }

  -- general purpose --

  -- walls --


  -- switches --


  -- floors --


  -- rails --


  -- liquids / animated --


  -- other --

---  O_PILL   = { t="SKULLSB2", f="O_PILL",  sane=1 }
---  O_BOLT   = { t="DOORWOOD", f="O_BOLT",  sane=1 }
---  O_CARVE  = { t="CHAINSD",  f="O_CARVE", sane=1 }
}


ABSOLUTION.LIQUIDS =
{
  water  = { mat="FLTFLWW1", color=0x282fcc, light=0.65, special=0 }
  water2 = { mat="FLTWAWA1", color=0x282fcc, light=0.65, special=0 }
  sludge = { mat="FLTSLUD1", color=0x3e453d, light=0.65, special=16, damage=20 }
  lava   = { mat="FLATHUH1", color=0x851b00, light=0.75, special=16, damage=20 }
  magma  = { mat="FLTLAVA1", color=0x442b2b, light=0.65, special=16, damage=20 }
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


ABSOLUTION.THEME_DEFAULTS =
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


  ---- OTHER STUFF ------------------

}


ABSOLUTION.LEVEL_THEMES =
{
  absolution_tech1 =
  {
    prob = 50

    liquids = { water=50, sludge=15, lava=4 }

    buildings = { Tech_generic=50 }

    hallways = { Castle_hallway=50 }  -- FIXME

    caves = { Cave_generic=50 }

    outdoors = { Outdoors_generic=50 }

    --TODO: more stuff

  }

}


------------------------------------------------------------

ABSOLUTION.MONSTERS =
{
}


ABSOLUTION.WEAPONS =
{
}


ABSOLUTION.PICKUPS =
{
  -- HEALTH --



  -- ARMOR --



  -- AMMO --

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

