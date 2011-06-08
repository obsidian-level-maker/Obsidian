----------------------------------------------------------------
-- GAME DEF : Chex Quest 1
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2009 Enhas
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

CHEX1 = { }

CHEX1.ENTITIES =
{
  --- PLAYERS ---

  player1 = { id=1, kind="other", r=16,h=56 }
  player2 = { id=2, kind="other", r=16,h=56 }
  player3 = { id=3, kind="other", r=16,h=56 }
  player4 = { id=4, kind="other", r=16,h=56 }

  dm_player     = { id=11, kind="other", r=16,h=56 }
  teleport_spot = { id=14, kind="other", r=16,h=56 }

  --- MONSTERS ---

  commonus      = { id=3004,kind="monster", r=20,h=56 }
  bipedicus     = { id=9,   kind="monster", r=20,h=56 }
  armored_biped = { id=3001,kind="monster", r=20,h=56 }
  cycloptis     = { id=3002,kind="monster", r=30,h=56 }

  --- BOSSES ---

  Flembrane = { id=3003,kind="monster", r=44,h=100 }

  --- PICKUPS ---

  k_red    = { id=13, kind="pickup", r=20,h=16, pass=true }
  k_yellow = { id=6,  kind="pickup", r=20,h=16, pass=true }
  k_blue   = { id=5,  kind="pickup", r=20,h=16, pass=true }

  large_zorcher   = { id=2001, kind="pickup", r=20,h=16, pass=true }
  rapid_zorcher   = { id=2002, kind="pickup", r=20,h=16, pass=true }
  zorch_propulsor = { id=2003, kind="pickup", r=20,h=16, pass=true }
  phasing_zorcher = { id=2004, kind="pickup", r=20,h=16, pass=true }
  super_bootspork = { id=2005, kind="pickup", r=20,h=16, pass=true }
  laz_device      = { id=2006, kind="pickup", r=20,h=16, pass=true }

  back_pack      = { id=   8, kind="pickup", r=20,h=16, pass=true }
  slime_suit     = { id=2025, kind="pickup", r=20,h=60, pass=true }
  allmap         = { id=2026, kind="pickup", r=20,h=16, pass=true }

  water       = { id=2014, kind="pickup", r=20,h=16, pass=true }
  fruit       = { id=2011, kind="pickup", r=20,h=16, pass=true }
  vegetables  = { id=2012, kind="pickup", r=20,h=16, pass=true }
  supercharge = { id=2013, kind="pickup", r=20,h=16, pass=true }

  repellent   = { id=2015, kind="pickup", r=20,h=16, pass=true }
  armor       = { id=2018, kind="pickup", r=20,h=16, pass=true }
  super_armor = { id=2019, kind="pickup", r=20,h=16, pass=true }

  mini_zorch      = { id=2007, kind="pickup", r=20,h=16, pass=true }
  mini_pack       = { id=2048, kind="pickup", r=20,h=16, pass=true }
  large_zorch     = { id=2008, kind="pickup", r=20,h=16, pass=true }
  large_pack      = { id=2049, kind="pickup", r=20,h=16, pass=true }
  propulsor_zorch = { id=2010, kind="pickup", r=20,h=16, pass=true }
  propulsor_pack  = { id=2046, kind="pickup", r=20,h=16, pass=true }
  phasing_zorch   = { id=2047, kind="pickup", r=20,h=16, pass=true }
  phasing_pack    = { id=  17, kind="pickup", r=20,h=16, pass=true }

  --- SCENERY ---

  -- TECH --

  landinglight = { id=2028,kind="scenery", r=16,h=35, light=255 }
  lightcolumn  = { id=55,  kind="scenery", r=16,h=86, light=255 }

  flag_pole  = { id=37, kind="scenery", r=16,h=128 }
  gas_tank   = { id=35, kind="scenery", r=16,h=36 }
  spaceship  = { id=48, kind="scenery", r=16,h=52 }

  chemical_burner = { id=41, kind="scenery", r=16,h=25 }
  chemical_flask  = { id=34, kind="scenery", r=16,h=16, pass=true }
  submerged_plant = { id=31, kind="scenery", r=16,h=42 }

  -- ARBORETUM --

  apple_tree   = { id=47, kind="scenery", r=16,h=92,  add_mode="island" }
  banana_tree  = { id=54, kind="scenery", r=31,h=108, add_mode="island" }
  orange_tree  = { id=43, kind="scenery", r=16,h=92,  add_mode="island" }
  tall_flower  = { id=28, kind="scenery", r=20,h=25,  add_mode="island" }
  tall_flower2 = { id=25, kind="scenery", r=20,h=25,  add_mode="island" }

  -- CAVE --

  column         = { id=32, kind="scenery", r=16,h=128 }
  stalagmite     = { id=30, kind="scenery", r=16,h=60 }
  mine_cart      = { id=33, kind="scenery", r=16,h=30 }
  slime_fountain = { id=44, kind="scenery", r=16,h=48 }

  -- MISC --
 
  civilian1 = { id=45, kind="scenery", r=16,h=54 }
  civilian2 = { id=56, kind="scenery", r=16,h=54 }
  civilian3 = { id=57, kind="scenery", r=16,h=48 }
}


CHEX1.PARAMETERS =
{
  rails = true
  switches = true
  liquids = true
  teleporters = true
  infighting = true

  custom_flats = true

  max_name_length = 28

  skip_monsters = { 10,35 }

  time_factor   = 1.0
  damage_factor = 1.0
  ammo_factor   = 0.8
  health_factor = 0.7
}


----------------------------------------------------------------

CHEX1.MATERIALS =
{
  -- special materials --
  _ERROR = { t="SHAWN2", f="FLOOR0_5" }
  _SKY   = { t="SHAWN2", f="F_SKY1" }


  -- walls --

  PIPEY    = { t="STONE",  f="##" }
  PANELS   = { t="STONE3", f="##" }

STARG3   = { t="STARG3",  f="FLOOR0_5" }
STARTAN1 = { t="STARTAN1", f="FLOOR0_5" }


  -- floors --

  LIFT     = { f="STEP", t="COMPBLUE" }

  VENT     = { f="", t="ASHWALL" }

CEIL4_1  = { t="STARG3", f="CEIL4_1" }
FLOOR0_5 = { t="STARG3", f="FLOOR0_5" }


  -- doors --

  DOOR_GRATE = { t="BIGDOOR1", f="##" }
  DOOR_ALUM  = { t="DOOR1",    f="##" }
  DOOR_METER = { t="DOORBLU2", f="##" }

  DOOR_BLUE   = { t="BRNBIGR",  f="##" }
  DOOR_RED    = { t="BRNBIGL",  f="##" }
  DOOR_YELLOW = { t="BRNSMAL2", f="##" }

  DOOR_HANGER = { t="STARTAN3", f="##" }

  TRACK = { t="COMPSTA1", f="##" }

  LIGHT_RED    = { t="DOORRED", f="##" }
  LIGHT_BLUE   = { t="DOORBLU", f="##" }
  LIGHT_YELLOW = { t="DOORYEL", f="##" }


  GRAY7    = { t="GRAY7",    f="##" }

  GRATE    = { t="REDWALL1", f="##" }


  -- switches --

  SW_METAL   = { t="SW2BLUE",  f="STEP" }
  SW_ROCK    = { t="SW1BRCOM", f="##"  }
  SW_BROWN2  = { t="SW1BRN2",  f="##"  }
  SW_CONC    = { t="SW1BROWN", f="##"  }
  SW_GRAY    = { t="SW1COMM",  f="##"  }
  SW_COMPUTE = { t="SW1COMP",  f="##"  }
  SW_STARTAN = { t="SW1METAL", f="##"  }
  SW_PIPEY   = { t="SW1STONE", f="##"  }


  -- liquids --

  WATER  = { t="GSTFONT1", f="FWATER1", sane=1 }
  SLIME1 = { t="FIREMAG1", f="NUKAGE1", sane=1 }
  SLIME2 = { t="FIREMAG1", f="LAVA1",   sane=1 }


  -- Oblige stuff --

  -- FIXME

  O_BOLT   = { t="CEMENT2",  f="O_BOLT", sane=1 }
}


CHEX1.RAILS =
{
  VINE1 = { t="MIDVINE1" }
}


CHEX1.LIQUIDS =
{
  water  = { mat="WATER", light=0.65 }

  -- these look very similar
  slime1 = { mat="SLIME1", light=0.65, special=5 }
  slime2 = { mat="SLIME2", light=0.65, special=5 }
}


----------------------------------------------------------------


CHEX1.THEME_DEFAULTS =
{
}


CHEX1.ROOM_THEMES =
{
  PLAIN = { }
}


CHEX1.LEVEL_THEMES =
-- TECH, ARBORETUM and CAVE?
{
  chex_tech1 =
  {
    building_walls =
    {
      BROWN=50,
    }

    building_floors =
    {
      FLOOR0_5=50,
    }

    building_ceilings =
    {
      CEIL4_1=50,
    }
    
    courtyard_floors =
    {
      BROWN2=50,
    }
  }
}


------------------------------------------------------------

-- Monster list
-- ============

-- nearly all the settings below for monsters, weapons and items
-- are the same as doom.lua, except the probs for monsters

CHEX1.MONSTERS =
{
  commonus =
  {
    prob=60,
    health=20
    damage=4
    attack="melee"
  }

  bipedicus =
  {
    prob=45
    health=30
    damage=10
    attack="melee"
  }

  armored_biped =
  {
    prob=35
    crazy_prob=65
    health=60
    damage=20
    attack="missile"
  }

  cycloptis =
  {
    prob=30
    health=150
    damage=25
    attack="melee"
    weap_prefs={ zorch_propulsor=0.5 }
  }

  -- only used in E1M5, and is stationary (wall monster, with level exit behind it)

  Flembrane =
  {
    health=1000
    damage=45
    attack="missile"
    weap_prefs={ laz_device=3.0 }
  }
}


-- Weapon list
-- ===========

CHEX1.WEAPONS =
{
  spoon =
  {
    rate=1.5
    damage=10
    attack="melee"
  }

  super_bootspork =
  {
    pref=3
    add_prob=2
    start_prob=1
    rate=8.7
    damage=10
    attack="melee"
  }

  mini_zorcher =
  {
    pref=5
    rate=1.8
    damage=10
    attack="hitscan"
    ammo="bullet"
    per=1
  }

  rapid_zorcher =
  {
    pref=70
    add_prob=35
    start_prob=40
    rate=8.5
    damage=10
    attack="hitscan"
    ammo="bullet"
    per=1
    give={ {ammo="bullet",count=20} }
  }

  large_zorcher =
  {
    pref=70
    add_prob=10
    start_prob=60
    rate=0.9
    damage=70
    attack="hitscan"
    splash={ 0
    0 }
    ammo="shell"
    per=1
    give={ {ammo="shell",count=8} }
  }

  zorch_propulsor =
  {
    pref=50
    add_prob=25
    start_prob=10
    rate=1.7
    damage=80
    attack="missile"
    splash={ 50,20,5 }
    ammo="rocket"
    per=1
    give={ {ammo="rocket",count=2} }
  }

  phasing_zorcher =
  {
    pref=90
    add_prob=13
    start_prob=5
    rate=11
    damage=20
    attack="missile"
    ammo="cell"
    per=1
    give={ {ammo="cell",count=40} }
  }

  laz_device =
  {
    pref=30
    add_prob=30
    start_prob=0.2
    rarity=4
    rate=0.8
    damage=300
    attack="missile"
    splash={60,45,30,30,20,10}
    ammo="cell"
    per=40
    give={ {ammo="cell",count=40} }
  }
}


-- Pickup List
-- ===========

CHEX1.PICKUPS =
{
  -- HEALTH --

  water =
  {
    prob = 20
    cluster = { 4,7 }
    give = { {health=1} }
  }

  fruit =
  {
    prob = 60
    cluster = { 2,5 }
    give = { {health=10} }
  }

  vegetables =
  {
    prob = 100
    cluster = { 1,3 }
    give = { {health=25} }
  }

  supercharge =
  {
    prob = 3
    big_item = true
    give = { {health=150} }
  }

  -- ARMOR --

  repellent =
  {
    prob = 10
    armor = true
    cluster = { 4,7 }
    give = { {health=1} }
  }

  armor =
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

  mini_zorch =
  {
    prob = 10
    cluster = { 2,5 }
    give = { {ammo="bullet",count=10} }
  }

  mini_pack =
  {
    prob = 40
    cluster = { 1,3 }
    give = { {ammo="bullet", count=50} }
  }

  large_zorch =
  {
    prob = 20
    cluster = { 2,5 }
    give = { {ammo="shell",count=4} }
  }

  large_pack =
  {
    prob = 40
    cluster = { 1,3 }
    give = { {ammo="shell",count=20} }
  }

  propulsor_zorch =
  {
    prob = 10
    cluster = { 4,7 }
    give = { {ammo="rocket",count=1} }
  }

  propulsor_pack =
  {
    prob = 40
    cluster = { 1,3 }
    give = { {ammo="rocket",count=5} }
  }

  phasing_zorch =
  {
    prob = 20
    cluster = { 2,5 }
    give = { {ammo="cell",count=20} }
  }

  phasing_pack =
  {
    prob = 40
    cluster = { 1,2 }
    give = { {ammo="cell",count=100} }
  }
}


CHEX1.PLAYER_MODEL =
{
  chexguy =
  {
    stats   = { health=0 }
    weapons = { mini_zorcher=1, spoon=1 }
  }
}


------------------------------------------------------------

CHEX1.EPISODES =
-- Chex Quest only has one episode of five levels
{
}


function CHEX1.setup()
 -- TODO
end


function CHEX1.get_levels()
  local EP_NUM  = 1
  local MAP_NUM = 1

  if OB_CONFIG.length == "few"     then MAP_NUM = 2 end
  if OB_CONFIG.length == "episode" then MAP_NUM = 5 end
  if OB_CONFIG.length == "full"    then MAP_NUM = 5 ; EP_NUM = 1 end

  for episode = 1,EP_NUM do
    for map = 1,MAP_NUM do

      local LEV =
      {
        name  = string.format("E%dM%d", episode, map)
        patch = string.format("WILV%d%d", episode-1, map-1)

        episode  = episode
        ep_along = map / MAP_NUM
        ep_info  = { }

        name_theme = "TECH"

      }

      table.insert(GAME.levels, LEV)
    end -- for map

  end -- for episode
end


function CHEX1.begin_level()
  -- set the description here
  if not LEVEL.description and LEVEL.name_theme then
    LEVEL.description = Naming_grab_one(LEVEL.name_theme)
  end
end



------------------------------------------------------------

OB_GAMES["chex1"] =
{
  label = "Chex Quest"

  format = "doom"

  tables =
  {
    CHEX
  }

  hooks =
  {
    setup        = CHEX1.setup,
    get_levels   = CHEX1.get_levels,
    begin_level  = CHEX1.begin_level,
  }
}


------------------------------------------------------------

OB_THEMES["chex_tech"] =
{
  label = "Tech"
  for_games = { chex=1 }
  name_theme = "TECH"
  mixed_prob = 60
}

UNFINISHED["chex_arboretum"] =
{
  label = "Arboretum"
  for_games = { chex=1 }
  name_theme = "URBAN"
  mixed_prob = 30
}

UNFINISHED["chex_cave"] =
{
  label = "Cave"
  for_games = { chex=1 }
  name_theme = "GOTHIC"
  mixed_prob = 30
}

