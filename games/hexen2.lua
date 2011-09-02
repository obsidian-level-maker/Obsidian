----------------------------------------------------------------
-- GAME DEF : Hexen II
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2010 Andrew Apted
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

HEXEN2 = { }

HEXEN2.ENTITIES =
{
  -- players
  player1 = { id="info_player_start", kind="other", r=16,h=56 }
  player2 = { id="info_player_coop",  kind="other", r=16,h=56 }
  player3 = { id="info_player_coop",  kind="other", r=16,h=56 }
  player4 = { id="info_player_coop",  kind="other", r=16,h=56 }

  dm_player = { id="info_player_deathmatch", kind="other", r=16,h=56 }

  -- enemies
  archer    = { id="monster_archer",      kind="monster", r=32, h=80 }
  archer2   = { id="monster_archer_lord", kind="monster", r=32, h=80 }
  mummy     = { id="monster_mummy",       kind="monster", r=32, h=80 }
  mummy2    = { id="monster_mummy_lord",  kind="monster", r=32, h=80 }
  imp_fire  = { id="monster_imp_fire",    kind="monster", r=32, h=80 }
  imp_ice   = { id="monster_imp_ice",     kind="monster", r=32, h=80 }

  golem_s   = { id="monster_golem_stone",  kind="monster", r=32, h=80 }
  golem_i   = { id="monster_golem_iron",   kind="monster", r=32, h=80 }
  golem_b   = { id="monster_golem_bronze", kind="monster", r=32, h=80 }
  scorpion1 = { id="monster_scorpion_yellow", kind="monster", r=32, h=80 }
  scorpion2 = { id="monster_scorpion_black",  kind="monster", r=32, h=80 }

  spider_r1 = { id="monster_spider_red_small",    kind="monster", r=32, h=80 }
  spider_r2 = { id="monster_spider_red_large",    kind="monster", r=32, h=80 }
  spider_y1 = { id="monster_spider_yellow_small", kind="monster", r=32, h=80 }
  spider_y2 = { id="monster_spider_yellow_large", kind="monster", r=32, h=80 }

  fish     = { id="monster_fish",        kind="monster", r=32, h=80 }
  rat      = { id="monster_rat",         kind="monster", r=32, h=80 }
  jaguar   = { id="monster_werejaguar",  kind="monster", r=32, h=80 }
  panther  = { id="monster_werepanther", kind="monster", r=32, h=80 }
  hydra    = { id="monster_hydra",       kind="monster", r=32, h=80 }

  medusa   = { id="monster_medusa_green",      kind="monster", r=32, h=80 }
  wizard1  = { id="monster_skull_wizard",      kind="monster", r=32, h=80 }
  wizard2  = { id="monster_skull_wizard_lord", kind="monster", r=32, h=80 }
  angle1   = { id="monster_fallen_angel",      kind="monster", r=32, h=80 }
  angle2   = { id="monster_fallen_angel_lord", kind="monster", r=32, h=80 }

  -- bosses


  -- weapons
  p_vorpal    = { id="wp_weapon2",       kind="pickup", r=30, h=30, pass=true }
  p_axe       = { id="wp_weapon3",       kind="pickup", r=30, h=30, pass=true }
  p1_purifier = { id="wp_weapon4_head",  kind="pickup", r=30, h=30, pass=true }
  p2_purifier = { id="wp_weapon4_staff", kind="pickup", r=30, h=30, pass=true }

  c_ice    = { id="wp_weapon2",       kind="pickup", r=30, h=30, pass=true }
  c_meteor = { id="wp_weapon3",       kind="pickup", r=30, h=30, pass=true }
  c1_sun   = { id="wp_weapon4_head",  kind="pickup", r=30, h=30, pass=true }
  c2_sun   = { id="wp_weapon4_staff", kind="pickup", r=30, h=30, pass=true }

  n_magic  = { id="wp_weapon2",       kind="pickup", r=30, h=30, pass=true }
  n_bone   = { id="wp_weapon3",       kind="pickup", r=30, h=30, pass=true }
  n1_staff = { id="wp_weapon4_head",  kind="pickup", r=30, h=30, pass=true }
  n2_staff = { id="wp_weapon4_staff", kind="pickup", r=30, h=30, pass=true }

  a_crossbow   = { id="wp_weapon2",       kind="pickup", r=30, h=30, pass=true }
  a_grenade    = { id="wp_weapon3",       kind="pickup", r=30, h=30, pass=true }
  a1_vindictus = { id="wp_weapon4_head",  kind="pickup", r=30, h=30, pass=true }
  a2_vindictus = { id="wp_weapon4_staff", kind="pickup", r=30, h=30, pass=true }

  -- pickups
  blue_mana  = { id="item_mana_blue",  kind="pickup", r=20,h=16, pass=true }
  green_mana = { id="item_mana_green", kind="pickup", r=20,h=16, pass=true }
  dual_mana  = { id="item_mana_both",  kind="pickup", r=20,h=16, pass=true }

  health    = { id="item_health",  kind="pickup", r=30, h=30, pass=true }


  -- scenery


  -- special

  trigger    = { id="trigger_multiple", kind="other", r=1, h=1, pass=true }
  change_lev = { id="trigger_changelevel", kind="other", r=1, h=1, pass=true }
  teleport   = { id="trigger_teleport", kind="other", r=1, h=1, pass=true }

  light = { id="light",      kind="other", r=1, h=1, pass=true }
  sun   = { id="oblige_sun", kind="other", r=1, h=1, pass=true }
}


HEXEN2.PARAMETERS =
{
  sub_format = "hexen2"

  -- TODO

  -- Quake engine needs all coords to lie between -4000 and +4000.
  seed_limit = 42

  centre_map = true

  use_spawnflags = true
  entity_delta_z = 24

  bridges = true
  extra_floors = true

  -- FIXME: check this
  jump_height = 42

  max_name_length = 20

  skip_monsters = { 10,30 }

  time_factor   = 1.0
  damage_factor = 1.0
  ammo_factor   = 0.8
  health_factor = 0.7
}


----------------------------------------------------------------

HEXEN2.MATERIALS =
{
  -- special materials --
  _ERROR = { t="error" }
  _SKY   = { t="sky001" }

  FLOOR  = { t="rtex001" }
  WALL   = { t="rtex238" }

  -- special stuff
  TRIGGER    = { t="trigger" }

  TELEPORT   = { t="*teleport" }

  -- FIXME
}


----------------------------------------------------------------

HEXEN2.SKINS =
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

HEXEN2.THEME_DEFAULTS =
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


HEXEN2.LEVEL_THEMES =
{
  hexen2_gothic1 =
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
  }
}


----------------------------------------------------------------

HEXEN2.MONSTERS =
{
  archer =
  {
    prob = 50
    health = 25
    damage = 5
    attack = "missile"
  }

  archer2 =
  {
    prob = 20
    health = 30
    damage = 14
    attack = "missile"
  }

  mummy =
  {
    prob = 40
    health = 80
    damage = 18
    attack = "melee"
  }

  mummy2 =
  {
    prob = 10
    health = 80
    damage = 10
    attack = "melee"
    density = 0.3
  }

  imp_fire =
  {
    prob = 60
    health = 75
    damage = 9
    attack = "missile"
  }

  imp_ice =
  {
    prob = 30
    health = 250
    damage = 30
    attack = "missile"
  }

  golem_s =
  {
    prob = 20
    health = 200
    damage = 15
    attack = "melee"
  }

  golem_i =
  {
    prob = 20
    health = 200
    damage = 15
    attack = "melee"
  }

  golem_b =
  {
    prob = 20
    health = 200
    damage = 15
    attack = "melee"
  }

  rat =
  {
    prob = 10
    health = 30
    damage = 20
    attack = "melee"
  }

  jaguar =
  {
    prob = 10
    health = 30
    damage = 20
    attack = "melee"
  }

  panther =
  {
    prob = 10
    health = 30
    damage = 20
    attack = "melee"
  }

  -- FIXME : the rest
}


HEXEN2.WEAPONS =
{
  -- FIXME !!!!  THESE STATS ARE TOTALLY BOGUS !!

  -- Paladin --

  p_gauntlet =
  {
    attack = "melee"
    rate = 2.0
    damage = 20
    slot = 1
  }

  p_vorpal =
  {
    pref = 50
    add_prob = 40
    attack = "missile"
    rate = 1.4
    damage = 45
    ammo = "blue_mana"
    per = 2
    slot = 2
  }

  p_axe =
  {
    pref = 30
    add_prob = 40
    rate = 1.4
    damage = 45
    attack = "missile"
    ammo = "green_mana"
    per = 2
    slot = 3
  }

  p_purifier =
  {
    pref = 30
    rate = 1.4
    damage = 45
    attack = "missile"
    ammo = "dual_mana"
    per = 4
    slot = 4
  }

  -- Crusader --

  c_hammer =
  {
    attack = "melee"
    rate = 2.0
    damage = 20
    slot = 1
  }

  c_ice =
  {
    pref = 50
    add_prob = 40
    attack = "missile"
    rate = 1.4
    damage = 45
    ammo = "blue_mana"
    per = 2
    slot = 2
  }

  c_meteor =
  {
    pref = 30
    add_prob = 40
    rate = 1.4
    damage = 45
    attack = "missile"
    ammo = "green_mana"
    per = 2
    slot = 3
  }

  c_sun =
  {
    pref = 30
    rate = 1.4
    damage = 45
    attack = "missile"
    ammo = "dual_mana"
    per = 4
    slot = 4
  }

  -- Necromancer --

  n_sickle =
  {
    attack = "melee"
    rate = 2.0
    damage = 20
    slot = 1
  }

  n_magic =
  {
    pref = 50
    add_prob = 40
    attack = "missile"
    rate = 1.4
    damage = 45
    ammo = "blue_mana"
    per = 2
    slot = 2
  }

  n_bone =
  {
    pref = 30
    add_prob = 40
    rate = 1.4
    damage = 45
    attack = "missile"
    ammo = "green_mana"
    per = 2
    slot = 3
  }

  n_staff =
  {
    pref = 30
    rate = 1.4
    damage = 45
    attack = "missile"
    ammo = "dual_mana"
    per = 4
    slot = 4
  }

  -- Assassin --

  a_dagger =
  {
    attack = "melee"
    rate = 2.0
    damage = 20
    slot = 1
  }

  a_crossbow =
  {
    pref = 50
    add_prob = 40
    attack = "missile"
    rate = 1.4
    damage = 45
    ammo = "blue_mana"
    per = 2
    slot = 2
  }

  a_grenade =
  {
    pref = 30
    add_prob = 40
    rate = 1.4
    damage = 45
    attack = "missile"
    ammo = "green_mana"
    per = 2
    slot = 3
  }

  a_vindictus =
  {
    pref = 30
    rate = 1.4
    damage = 45
    attack = "missile"
    ammo = "dual_mana"
    per = 4
    slot = 4
  }
}


HEXEN2.PICKUPS =
{
  -- HEALTH --

  health =
  {
    prob = 50
    give = { {health=25} }
  }


  -- ARMOR --


  -- AMMO --

  blue_mana =
  {
    prob = 10
    give = { {ammo="blue_mana",count=20} }
  }

  green_mana =
  {
    prob = 10
    give = { {ammo="green_mana",count=20} }
  }

}


HEXEN2.PLAYER_MODEL =
{
  paladin =
  {
    stats   = { health=0 }
    weapons = { p_gauntlet=1 }
  }

  crusader =
  {
    stats   = { health=0 }
    weapons = { c_hammer=1 }
  }

  necromancer =
  {
    stats   = { health=0 }
    weapons = { n_sickle=1 }
  }

  assassin =
  {
    stats   = { health=0 }
    weapons = { a_dagger=1 }
  }
}


------------------------------------------------------------

HEXEN2.EPISODES =
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

  episode5 =
  {
    theme = "TECH"
    sky_light = 0.75
  }
}


----------------------------------------------------------------

function HEXEN2.setup()
  -- nothing needed
end


function HEXEN2.get_levels()
  local  EP_NUM = (OB_CONFIG.length == "full"   ? 5 ; 1)
  local MAP_NUM = (OB_CONFIG.length == "single" ? 1 ; 5)

  if OB_CONFIG.length == "few"     then MAP_NUM = 3 end
  if OB_CONFIG.length == "episode" then MAP_NUM = 7 end

  for ep_index = 1,EP_NUM do
    local EPI =
    {
      levels = {}
    }

    table.insert(GAME.episodes, EPI)

    local ep_info = HEXEN2.EPISODES["episode" .. ep_index]
    assert(ep_info)

    for map = 1,MAP_NUM do

      local LEV =
      {
        episode = EPI

        name     = string.format("e%dm%d", ep_index, map)
        next_map = string.format("e%dm%d", ep_index, map+1)

         ep_along = map / MAP_NUM
        mon_along = (map + ep_index - 1) / MAP_NUM
      }

      table.insert( EPI.levels, LEV)
      table.insert(GAME.levels, LEV)
    end -- for map

  end -- for episode
end


function HEXEN2.begin_level()
  -- find the texture wad
  local primary_tex_wad = gui.locate_data("hexen2_tex.wd2")

  if not primary_tex_wad then
    error("cannot find texture file: hexen2_tex.wd2\n\n" ..
          "Please visit the OBLIGE website for full information on " ..
          "how to setup Hexen 2 support.")
  end

  gui.q1_add_tex_wad(primary_tex_wad)

  -- set the description here
  if not LEVEL.description and LEVEL.name_theme then
    LEVEL.description = Naming_grab_one(LEVEL.name_theme)
  end
end


----------------------------------------------------------------

OB_GAMES["hexen2"] =
{
  label = "Hexen 2"

  format = "quake"

  tables =
  {
    HEXEN2
  }

  hooks =
  {
    setup        = HEXEN2.setup
    get_levels   = HEXEN2.get_levels
    begin_level  = HEXEN2.begin_level
  }
}


OB_THEMES["hexen2_gothic"] =
{
  label = "Gothic"
  for_games = { hexen2=1 }
  name_theme = "TECH"
  mixed_prob = 50
}

