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
  player1 = { id="info_player_start", r=16, h=56 }
  player2 = { id="info_player_coop",  r=16, h=56 }
  player3 = { id="info_player_coop",  r=16, h=56 }
  player4 = { id="info_player_coop",  r=16, h=56 }

  dm_player = { id="info_player_deathmatch" }

  -- weapons
  weapon2  = { id="wp_weapon2" }
  weapon3  = { id="wp_weapon3" }

  piece1   = { id="wp_weapon4_head" }
  piece2   = { id="wp_weapon4_staff" }

--[[
  p_vorpal    = { id="wp_weapon2" }
  p_axe       = { id="wp_weapon3" }
  p1_purifier = { id="wp_weapon4_head" }
  p2_purifier = { id="wp_weapon4_staff" }

  c_ice    = { id="wp_weapon2" }
  c_meteor = { id="wp_weapon3" }
  c1_sun   = { id="wp_weapon4_head" }
  c2_sun   = { id="wp_weapon4_staff" }

  n_magic  = { id="wp_weapon2" }
  n_bone   = { id="wp_weapon3" }
  n1_staff = { id="wp_weapon4_head" }
  n2_staff = { id="wp_weapon4_staff" }

  a_crossbow   = { id="wp_weapon2" }
  a_grenade    = { id="wp_weapon3" }
  a1_vindictus = { id="wp_weapon4_head" }
  a2_vindictus = { id="wp_weapon4_staff" }
--]]

  -- keys
  k_pharaoh  = { id="puzzle_piece",
                 fields={ puzzle_id="e1", netname="Pharaoh's Key" } }
  k_anubia   = { id="puzzle_piece",
                 fields={ puzzle_id="ankey", netname="Key of Anubia" } }
  k_ra       = { id="puzzle_piece",
                 fields={ puzzle_id="rakey", netname="Key of Ra" } }
  k_horus    = { id="puzzle_piece",
                 fields={ puzzle_id="eyeh", netname="Eye of Horus" } }

  k_soul     = { id="puzzle_piece",
                 fields={ puzzle_id="soul", netname="Soul Key" } }
  k_stable   = { id="puzzle_piece",
                 fields={ puzzle_id="stkey", netname="Stable Key" } }
  k_tailor   = { id="puzzle_piece",
                 fields={ puzzle_id="takey", netname="Tailor's Key" } }
  k_treasury = { id="puzzle_piece",
                 fields={ puzzle_id="trkey", netname="Treasury Key" } }
  k_guardian = { id="puzzle_piece",
                 fields={ puzzle_id="s2", netname="Guardian Key" } }

  k_stone    = { id="puzzle_piece",
                 fields={ puzzle_id="m1", netname="Stone Key" } }
  k_skull    = { id="puzzle_piece",
                 fields={ puzzle_id="m2", netname="Crystal Skull" } }
  k_jade     = { id="puzzle_piece",
                 fields={ puzzle_id="m3", netname="Jade Skull" } }
  k_serpent  = { id="puzzle_piece",
                 fields={ puzzle_id="m4", netname="Serpent's Heart" } }

  k_fire     = { id="puzzle_piece",
                 fields={ puzzle_id="fire", netname="Element of Fire" } }
  k_water    = { id="puzzle_piece",
                 fields={ puzzle_id="water", netname="Element of Water" } }
  k_air      = { id="puzzle_piece",
                 fields={ puzzle_id="air", netname="Element of Air" } }
  k_earth    = { id="puzzle_piece",
                 fields={ puzzle_id="earth", netname="Element of Earth" } }

  k_crystal  = { id="puzzle_piece",
                 fields={ puzzle_id="r5", netname="Power Crystal" } }
  k_void     = { id="puzzle_piece",
                 fields={ puzzle_id="r6", netname="Void Stone" } }
  k_sun      = { id="puzzle_piece",
                 fields={ puzzle_id="r7", netname="Sun Stone" } }
  k_shadow   = { id="puzzle_piece",
                 fields={ puzzle_id="r8", netname="Shadow Stone" } }

  k_sphere   = { id="puzzle_piece",
                 fields={ puzzle_id="gsphere", netname="Gold Sphere" } }
  k_gold     = { id="puzzle_piece",
                 fields={ puzzle_id="r1", netname="Gold Bar" } }
  k_silver   = { id="puzzle_piece",
                 fields={ puzzle_id="silver", netname="Silver Bar" } }

  -- scenery


  -- special

  light = { id="light" }
  sun   = { id="oblige_sun" }

  trigger    = { id="trigger_multiple" }
  change_lev = { id="trigger_changelevel" }
  teleport   = { id="trigger_teleport" }
}


HEXEN2.PARAMETERS =
{
  sub_format = "hexen2"

  -- TODO

  -- Quake engine needs all coords to lie between -4000 and +4000.
  map_limit = 8000

  centre_map = true

  use_spawnflags = true
  entity_delta_z = 24

  bridges = true
  extra_floors = true

  -- special logic for Hexen weapon system
  hexen_weapons = true

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
  -- FIXME: THIS IS EXTREMELY INCOMPLETE....

  -- special materials --
  _ERROR = { t="error" }
  _SKY   = { t="sky001" }

  FLOOR  = { t="rtex001" }
  WALL   = { t="rtex238" }
  ROCK   = { t="rtex032" }

  -- special stuff
  TRIGGER    = { t="trigger" }

  TELEPORT   = { t="*teleport" }

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

  hub_keys = { k_stone = 50, k_tailor = 50, k_treasury = 50 }

  -- OLD CRUD
  teleporter_mat = "TELE_TOP"
  tele_dest_mat = "COP3_4"
  pedestal_mat = "LIGHT1_1"
  periph_pillar_mat = "METAL2_6"
  track_mat = "MET5_1"
}


HEXEN2.ROOM_THEMES =
{
  Castle_generic =
  {
    walls =
    {
      WALL=50,
    }

    floors =
    {
      FLOOR=50,
    }

    ceilings =
    {
      FLOOR=50,
    }

  }

  Cave_generic =
  {
    naturals =
    {
      ROCK=50,
    }
  }

  Outdoors_generic =
  {
    floors =
    {
      FLOOR=50,
    }

    naturals =
    {
      ROCK=50,
    }
  }
}


HEXEN2.LEVEL_THEMES =
{
  hexen2_castle1 =
  {
    prob = 50

    buildings = { Castle_generic=50 }

    caves = { Cave_generic=50 }

    outdoors = { Outdoors_generic=50 }
  }
}


----------------------------------------------------------------

HEXEN2.MONSTERS =
{
  -- FIXME !!!!  THESE STATS ARE TOTALLY BOGUS !!

  archer =
  {
    id = "monster_archer"
    r = 32
    h = 80
    prob = 50
    health = 25
    damage = 5
    attack = "missile"
  }

  archer2 =
  {
    id = "monster_archer_lord"
    r = 32
    h = 80
    prob = 20
    health = 30
    damage = 14
    attack = "missile"
  }

  mummy =
  {
    id = "monster_mummy"
    r = 32
    h = 80
    prob = 40
    health = 80
    damage = 18
    attack = "melee"
  }

  mummy2 =
  {
    id = "monster_mummy_lord"
    r = 32
    h = 80
    prob = 10
    health = 80
    damage = 10
    attack = "melee"
    density = 0.3
  }

  imp_fire =
  {
    id = "monster_imp_fire"
    r = 32
    h = 80
    prob = 60
    health = 75
    damage = 9
    attack = "missile"
    float = true
  }

  imp_ice =
  {
    id = "monster_imp_ice"
    r = 32
    h = 80
    prob = 30
    health = 250
    damage = 30
    attack = "missile"
    float = true
  }

  golem1 =
  {
    id = "monster_golem_stone"
    r = 32
    h = 80

    prob = 20
    health = 200
    damage = 15
    attack = "melee"
  }

  golem2 =
  {
    id = "monster_golem_iron"
    r = 32
    h = 80
    prob = 20
    health = 200
    damage = 15
    attack = "melee"
  }

  golem3 =
  {
    id = "monster_golem_bronze"
    r = 32
    h = 80
    prob = 20
    health = 200
    damage = 15
    attack = "melee"
  }

  golem4 =
  {
    id = "monster_golem_crystal"
    r = 32
    h = 80
    prob = 20
    health = 200
    damage = 15
    attack = "melee"
  }

  wizard =
  {
    id = "monster_skull_wizard"
    r = 32
    h = 80
    prob = 50
    health = 25
    damage = 5
    attack = "missile"
  }

  wizard2 =
  {
    id = "monster_skull_wizard_lord"
    r = 32
    h = 80
    prob = 20
    health = 30
    damage = 14
    attack = "missile"
  }

  angel =
  {
    id = "monster_fallen_angel"
    r = 32
    h = 80
    prob = 50
    health = 25
    damage = 5
    attack = "missile"
    float = true
  }

  angel2 =
  {
    id = "monster_fallen_angel_lord"
    r = 32
    h = 80
    prob = 20
    health = 30
    damage = 14
    attack = "missile"
    float = true
  }

  --- Animals ---

  rat =
  {
    id = "monster_rat"
    r = 32
    h = 80

    prob = 10
    health = 30
    damage = 20
    attack = "melee"
  }

  jaguar =
  {
    id = "monster_werejaguar"
    r = 32
    h = 80
    prob = 10
    health = 30
    damage = 20
    attack = "melee"
  }

  panther =
  {
    id = "monster_werepanther"
    r = 32
    h = 80
    prob = 10
    health = 30
    damage = 20
    attack = "melee"
  }

  raven =
  {
    id = "monster_raven"
    r = 32
    h = 80
    prob = 10
    health = 30
    damage = 20
    attack = "melee"
    float = true
  }

  fish =  -- only added in water
  {
    id = "monster_fish"
    r = 32
    h = 80
    health = 30
    damage = 20
    attack = "melee"
    swim = true
  }

  hydra =  -- only added in water
  {
    id = "monster_hydra"
    r = 32
    h = 80
    health = 30
    damage = 20
    attack = "melee"
    swim = true
  }

  scorpion1 =
  {
    id = "monster_scorpion_yellow"
    r = 32
    h = 80

    prob = 10
    health = 30
    damage = 20
    attack = "melee"
  }

  scorpion2 =
  {
    id = "monster_scorpion_black"
    r = 32
    h = 80
    prob = 10
    health = 30
    damage = 20
    attack = "melee"
  }

  spider_r1 =
  {
    id = "monster_spider_red_small"
    r = 32
    h = 80

    prob = 10
    health = 30
    damage = 20
    attack = "melee"
  }

  spider_r2 =
  {
    id = "monster_spider_red_large"
    r = 32
    h = 80
    prob = 10
    health = 30
    damage = 20
    attack = "melee"
  }

  spider_y1 =
  {
    id = "monster_spider_yellow_small"
    r = 32
    h = 80
    prob = 10
    health = 30
    damage = 20
    attack = "melee"
  }

  spider_y2 =
  {
    id = "monster_spider_yellow_large"
    r = 32
    h = 80
    prob = 10
    health = 30
    damage = 20
    attack = "melee"
  }

  -- TODO: medusa   = { id="monster_medusa_green", r=32, h=80 }

  -- BOSSES --

--[[ FIXME
  Snake    = { id="monster_snake",    r=32, h=80 }
  Famine   = { id="rider_famine",     r=32, h=80 }
  Pest     = { id="rider_pestilence", r=32, h=80 }
  War      = { id="rider_war",        r=32, h=80 }
  Death    = { id="rider_death",      r=32, h=80 }
  Eidolon  = { id="monster_eidolon",  r=32, h=80 }
--]]
}


HEXEN2.WEAPONS =
{
  -- FIXME !!!!  THESE STATS ARE TOTALLY BOGUS !!

  -- Paladin --

  p_gauntlet =
  {
    pref = 5
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
    pref = 5
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
    pref = 5
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
    pref = 5
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
    id = "item_health"
    prob = 50
    give = { {health=25} }
  }


  -- ARMOR --


  -- AMMO --

  blue_mana =
  {
    id = "item_mana_blue"
    prob = 10
    give = { {ammo="blue_mana",count=20} }
  }

  green_mana =
  {
    id = "item_mana_green"
    prob = 10
    give = { {ammo="green_mana",count=20} }
  }

  --TODO: dual_mana  = { id="item_mana_both" }
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
  local MAP_NUM = (OB_CONFIG.length == "single" ? 1 ; 7)

  for ep_index = 1,EP_NUM do
    local EPI =
    {
      levels = {}
    }

    table.insert(GAME.episodes, EPI)

    local ep_info = HEXEN2.EPISODES["episode" .. ep_index]
    assert(ep_info)

    for map = 1,MAP_NUM do
      local map_id = (ep_index - 1) * MAP_NUM + map

      local ep_along = map / MAP_NUM

      if MAP_NUM == 1 then
        ep_along = rand.range(0.3, 0.7)
      end

      local LEV =
      {
        episode = EPI

        name     = string.format("e%dm%d", ep_index, map)
        next_map = string.format("e%dm%d", ep_index, map+1)

        map = map_id
        local_map = map

         ep_along = map / MAP_NUM
        mon_along = (map + ep_index - 1) / MAP_NUM
      }

      -- second last map in each episode is a secret level, and
      -- last map in each episode is the boss map.

      if map == 6 then
        LEV.kind = "SECRET"
      elseif map == 7 then
        LEV.kind = "BOSS"
      end

      -- very last map of the game?
      if ep_index == 5 and map == 7 then
        LEV.next_map = nil
      end

      table.insert( EPI.levels, LEV)
      table.insert(GAME.levels, LEV)
    end -- for map

    -- link hub together (unless only making a single level)

    if MAP_NUM > 1 then
      Hub_connect_levels(EPI, GAME.THEME_DEFAULTS.hub_keys)

      Hub_assign_weapons(EPI)
      Hub_assign_pieces(EPI, { "piece1", "piece2", "piece3" })
    end

  end -- for episode
end


function HEXEN2.begin_level()
  -- find the texture wad
  local primary_tex_wad = gui.locate_data("hexen2_tex.wd2")

  if not primary_tex_wad then
    error("cannot find texture file: hexen2_tex.wd2\n\n" ..
          "Please visit the following link which takes you to the " ..
          "Hexen 2 Setup documentation on the OBLIGE website: " ..
          "<a http://oblige.sourceforge.net/doc_usage.html#quake>Setting Up Hexen 2</a>")
  end

  gui.q1_add_tex_wad(primary_tex_wad)
end


----------------------------------------------------------------

UNFINISHED["hexen2"] =
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


OB_THEMES["hexen2_castle"] =
{
  label = "Castle"
  for_games = { hexen2=1 }
  name_theme = "GOTHIC"
  mixed_prob = 50
}

