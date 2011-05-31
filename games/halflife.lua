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
  player1 = { id="info_player_start", kind="other", r=16,h=56 }

  -- FIXME !!!
  player2 = { id="item_healthkit",  kind="other", r=16,h=56 }
  player3 = { id="item_healthkit",  kind="other", r=16,h=56 }
  player4 = { id="item_healthkit",  kind="other", r=16,h=56 }

  dm_player = { id="info_player_deathmatch", kind="other", r=16,h=56 }

  -- enemies
  grunt    = { id="monster_alien_grunt", kind="monster", r=32, h=80, }
  slave    = { id="monster_alien_slave", kind="monster", r=32, h=80, }
  garg     = { id="monster_gargantua",   kind="monster", r=32, h=80, }

  baby     = { id="monster_babycrab",    kind="monster", r=32, h=80, }
  crab     = { id="monster_headcrab",    kind="monster", r=32, h=80, }
  chicken  = { id="monster_bullchicken", kind="monster", r=32, h=80, }
  roach    = { id="monster_cockroach",   kind="monster", r=32, h=80, }
  hound    = { id="monster_houndeye",    kind="monster", r=32, h=80, }

  saur     = { id="monster_ichthyosaur", kind="monster", r=32, h=80, }
  snark    = { id="monster_snark",       kind="monster", r=32, h=80, }
  zombie   = { id="monster_zombie",      kind="monster", r=32, h=80, }

  -- bosses

  -- NPCs
  barney    = { id="monster_barney",     kind="other", r=32, h=80, }
  scientist = { id="monster_scientist",  kind="other", r=32, h=80, }

  -- pickups

  crowbar  = { id="weapon_crowbar",    kind="pickup", r=30, h=30, pass=true }
  shotty   = { id="weapon_shotgun",    kind="pickup", r=30, h=30, pass=true }
  nine_AR  = { id="weapon_9mmAR",      kind="pickup", r=30, h=30, pass=true }
  handgun  = { id="weapon_9mmhandgun", kind="pickup", r=30, h=30, pass=true }

  snark    = { id="weapon_snark",    kind="pickup", r=30, h=30, pass=true }
  rpg      = { id="weapon_rpg",      kind="pickup", r=30, h=30, pass=true }
  w357     = { id="weapon_357",      kind="pickup", r=30, h=30, pass=true }
  gauss    = { id="weapon_gauss",    kind="pickup", r=30, h=30, pass=true }

  buckshot  = { id="ammo_buckshot", kind="pickup", r=30, h=30, pass=true }
  clip      = { id="ammo_9mmAR",    kind="pickup", r=30, h=30, pass=true }

  health    = { id="item_healthkit", kind="pickup", r=30, h=30, pass=true }


  -- scenery


  -- special

  trigger    = { id="trigger_multiple", kind="other", r=1, h=1, pass=true }
  change_lev = { id="trigger_changelevel", kind="other", r=1, h=1, pass=true }
  teleport   = { id="trigger_teleport", kind="other", r=1, h=1, pass=true }

  light = { id="light",      kind="other", r=1, h=1, pass=true }
  sun   = { id="oblige_sun", kind="other", r=1, h=1, pass=true }

}


HALFLIFE.PARAMETERS =
{
  sub_format = "halflife"

  -- TODO

  -- FIXME: verify if HL engine needs all coords to lie between -4000 and +4000.
  seed_limit = 42

  centre_map = true

  use_spawnflags = true
  entity_delta_z = 24

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
    _stairs = { up=1 }
  }

  Stair_Down1 =
  {
    _prefab = "NICHE_STAIR_8"
    _where  = "chunk"
    _stairs = { down=1 }
  }
}


----------------------------------------------------------------

HALFLIFE.SUB_THEME_DEFAULTS =
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


HALFLIFE.SUB_THEMES =
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
    prob = 20
    health = 25
    damage = 5
    attack = "melee"
  }

  grunt =
  {
    prob = 80
    health = 30
    damage = 14
    attack = "hitscan"
  }

  garg =
  {
    prob = 3
    health = 80
    damage = 10
    attack = "melee"
    density = 0.3
  }

  chicken =
  {
    prob = 60
    health = 75
    damage = 9
    attack = "melee"
  }

  hound =
  {
    prob = 30
    health = 250
    damage = 30
    attack = "missile"
  }

  roach =
  {
    prob = 40
    health = 200
    damage = 15
    attack = "missile"
  }

  snark =
  {
    prob = 10
    health = 300
    damage = 20
    attack = "melee"
  }

  saur =
  {
    prob = 3
    health = 300
    damage = 20
    attack = "melee"
  }

  zombie =
  {
    prob = 60
    health = 80
    damage = 18
    attack = "missile"
  }
}


HALFLIFE.WEAPONS =
{
  crowbar =
  {
    attack = "melee"
    rate = 2.0
    damage = 20
  }

  shotty =
  {
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

}


HALFLIFE.PICKUPS =
{
  -- HEALTH --

  health =
  {
    prob = 50
    give = { {health=25} }
  }


  -- ARMOR --


  -- AMMO --

  buckshot =
  {
    prob = 10
    give = { {ammo="shell",count=20} }
  }

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
  local EP_NUM  = (OB_CONFIG.length == "full"   ? 4, 1)
  local MAP_NUM = (OB_CONFIG.length == "single" ? 1, 7)

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
      }

      table.insert(GAME.levels, LEV)
    end -- for map

  end -- for episode
end


function HALFLIFE.begin_level()
  -- set the description here
  if not LEVEL.description and LEVEL.name_theme then
    LEVEL.description = Naming_grab_one(LEVEL.name_theme)
  end
end


----------------------------------------------------------------

OB_GAMES["halflife"] =
{
  label = "Half-Life"

  format = "quake"

  tables =
  {
    HALFLIFE
  }

  hooks =
  {
    setup        = HALFLIFE.setup
    get_levels   = HALFLIFE.get_levels
    begin_level  = HALFLIFE.begin_level
  }
}


OB_THEMES["halflife_lab"] =
{
  label = "Lab"
  for_games = { halflife=1 }
  name_theme = "TECH"
  mixed_prob = 50
}

