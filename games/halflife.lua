----------------------------------------------------------------
-- GAME DEF : Half-Life
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2010-2011 Andrew Apted
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

HALFLIFE = { }

HALFLIFE.ENTITIES =
{
  -- players
  player1 = { id="info_player_start", r=16, h=56 }

  -- FIXME !!!
  player2 = { id="item_healthkit",  r=16, h=56 }
  player3 = { id="item_healthkit",  r=16, h=56 }
  player4 = { id="item_healthkit",  r=16, h=56 }

  dm_player = { id="info_player_deathmatch" }

  -- enemies

  -- bosses

  -- NPCs
  barney    = { id="monster_barney",     r=32, h=80, }
  scientist = { id="monster_scientist",  r=32, h=80, }




  -- scenery


  -- special

  light = { id="light" }
  sun   = { id="oblige_sun" }

  trigger    = { id="trigger_multiple" }
  change_lev = { id="trigger_changelevel" }
  teleport   = { id="trigger_teleport" }
}


HALFLIFE.PARAMETERS =
{
  sub_format = "halflife"

  -- TODO

  -- FIXME: verify if HL engine needs all coords to lie between -4000 and +4000.
  map_limit = 8000

  centre_map = true

  use_spawnflags = true
  entity_delta_z = 24

  bridges = true
  extra_floors = true

  max_name_length = 20

  skip_monsters = { 10,30 }

  time_factor   = 1.0
  damage_factor = 1.0
  ammo_factor   = 0.8
  health_factor = 0.7
  monster_factor = 0.6
}


----------------------------------------------------------------

HALFLIFE.MATERIALS =
{
  -- special materials --
  _ERROR = { t="generic027" }
  _SKY   = { t="sky" }

  FLOOR  = { t="crete3_flr04" }
  WALL   = { t="fifties_wall14t" }

  -- special stuff
  TRIGGER    = { t="trigger" }

  TELEPORT   = { t="*teleport" }
}


----------------------------------------------------------------

HALFLIFE.SKINS =
{

  ----| STARTS |----

  Start_basic =
  {
    _prefab = "START_SPOT"

    top = "O_BOLT"
  }


  ----| EXITS |----

  Exit_basic =
  {
    _prefab = "QUAKE_EXIT_PAD"

    pad  = "DOORSWT2"
    side = "RED1_2"
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
}


----------------------------------------------------------------

HALFLIFE.THEME_DEFAULTS =
{
  starts = { Start_basic = 50 }

  exits = { Exit_basic = 50 }

  stairs = { Stair_Up1 = 50, Stair_Down1 = 50 }

  -- OLD CRUD
  teleporter_mat = "TELE_TOP"
  tele_dest_mat = "COP3_4"
  pedestal_mat = "LIGHT1_1"
  periph_pillar_mat = "METAL2_6"
  track_mat = "MET5_1"
}


HALFLIFE.LEVEL_THEMES =
{
  halflife_lab1 =
  {
    prob = 50

    building_walls =
    {
      WALL=50,
    }

    building_floors =
    {
      FLOOR=50,
    }

    building_ceilings =
    {
      FLOOR=50,
    }

    courtyard_floors =
    {
      FLOOR=50,
    }

    scenery =
    {
      -- FIXME
    }
  }  -- LAB1
}


----------------------------------------------------------------

HALFLIFE.MONSTERS =
{
  crab =
  {
    id = "monster_headcrab"
    r = 32
    h = 80
    prob = 20
    health = 25
    damage = 5
    attack = "melee"
  }

  grunt =
  {
    id = "monster_alien_grunt"
    r = 32
    h = 80
    prob = 80
    health = 30
    damage = 14
    attack = "hitscan"
  }

  garg =
  {
    id = "monster_gargantua"
    r = 32
    h = 80
    prob = 3
    health = 80
    damage = 10
    attack = "melee"
    density = 0.3
  }

  chicken =
  {
    id = "monster_bullchicken"
    r = 32
    h = 80
    prob = 60
    health = 75
    damage = 9
    attack = "melee"
  }

  hound =
  {
    id = "monster_houndeye"
    r = 32
    h = 80
    prob = 30
    health = 250
    damage = 30
    attack = "missile"
  }

  roach =
  {
    id = "monster_cockroach"
    r = 32
    h = 80
    prob = 40
    health = 200
    damage = 15
    attack = "missile"
  }

  snark =
  {
    id = "monster_snark"
    r = 32
    h = 80
    prob = 10
    health = 300
    damage = 20
    attack = "melee"
  }

  saur =
  {
    id = "monster_ichthyosaur"
    r = 32
    h = 80
    prob = 3
    health = 300
    damage = 20
    attack = "melee"
  }

  zombie =
  {
    id = "monster_zombie"
    r = 32
    h = 80
    prob = 60
    health = 80
    damage = 18
    attack = "missile"
  }

--TODO  slave    = { id="monster_alien_slave", r=32, h=80, }

--TODO  baby     = { id="monster_babycrab",    r=32, h=80, }
}


HALFLIFE.WEAPONS =
{
  crowbar =
  {
    id = "weapon_crowbar"
    attack = "melee"
    rate = 2.0
    damage = 20
  }

  shotty =
  {
    id = "weapon_shotgun"
    pref = 50
    add_prob = 40
    start_prob = 50
    attack = "hitscan"
    rate = 1.4
    damage = 45
    splash = {0,3}
    ammo = "shell"
    per = 2
    give = { {ammo="shell",count=5} }
  }

  w357 =
  {
    id = "weapon_357"
    pref = 50
    add_prob = 40
    start_prob = 50
    attack = "hitscan"
    rate = 1.4
    damage = 45
    splash = {0,3}
    ammo = "shell"
    per = 2
    give = { {ammo="shell",count=5} }
  }

  rpg =
  {
    id = "weapon_rpg"
    pref = 50
    add_prob = 40
    start_prob = 50
    attack = "hitscan"
    rate = 1.4
    damage = 45
    splash = {0,3}
    ammo = "shell"
    per = 2
    give = { {ammo="shell",count=5} }
  }

--[[ TODO
  nine_AR  = { id="weapon_9mmAR",      r=30, h=30, pass=true }
  handgun  = { id="weapon_9mmhandgun", r=30, h=30, pass=true }
  snark    = { id="weapon_snark",    r=30, h=30, pass=true }
  gauss    = { id="weapon_gauss",    r=30, h=30, pass=true }
--]]
}


HALFLIFE.PICKUPS =
{
  -- HEALTH --

  health =
  {
    id = "item_healthkit"
    prob = 50
    give = { {health=25} }
  }


  -- ARMOR --


  -- AMMO --

  buckshot =
  {
    id = "ammo_buckshot"
    prob = 10
    give = { {ammo="shell",count=20} }
  }

--TODO :  clip = { id="ammo_9mmAR",    r=30, h=30, pass=true }
}


HALFLIFE.PLAYER_MODEL =
{
  gordon =
  {
    stats   = { health=0 }
    weapons = { crowbar=1 }
  }
}


------------------------------------------------------------

HALFLIFE.EPISODES =
{
  episode1 =
  {
    theme = "TECH"
    sky_light = 0.75
  }

  episode2 =
  {
    theme = "TECH"
    sky_light = 0.75
  }

  episode3 =
  {
    theme = "TECH"
    sky_light = 0.75
  }

  episode4 =
  {
    theme = "TECH"
    sky_light = 0.75
  }
}


----------------------------------------------------------------

function HALFLIFE.setup()
  -- do stuff here
end


function HALFLIFE.get_levels()
  local EP_NUM  = (OB_CONFIG.length == "full"   ? 4 ; 1)
  local MAP_NUM = (OB_CONFIG.length == "single" ? 1 ; 7)

  if OB_CONFIG.length == "few" then MAP_NUM = 3 end

  for episode = 1,EP_NUM do
    local ep_info = HALFLIFE.EPISODES["episode" .. episode]
    assert(ep_info)

    for map = 1,MAP_NUM do

      local LEV =
      {
        name = string.format("e%dm%d", episode, map)
        next_map = string.format("e%dm%d", episode, map+1)

        episode  = episode
        map      = map
        ep_along = map / MAP_NUM
        mon_along = (map + episode - 1) / MAP_NUM
      }

      table.insert(GAME.levels, LEV)
    end -- for map

  end -- for episode
end


----------------------------------------------------------------

UNFINISHED["halflife"] =
{
  label = "Half-Life"

  format = "quake"

  tables =
  {
    HALFLIFE
  }

  hooks =
  {
    setup      = HALFLIFE.setup
    get_levels = HALFLIFE.get_levels
  }
}


OB_THEMES["halflife_lab"] =
{
  label = "Lab"
  for_games = { halflife=1 }
  name_theme = "TECH"
  mixed_prob = 50
}

