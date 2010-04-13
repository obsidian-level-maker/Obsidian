----------------------------------------------------------------
-- GAME DEF : Chex Quest
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2009 Enhas
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

CHEX = { }

CHEX.THINGS =
{
  --- PLAYERS ---

  player1 = { id=1, kind="other", r=16,h=56 },
  player2 = { id=2, kind="other", r=16,h=56 },
  player3 = { id=3, kind="other", r=16,h=56 },
  player4 = { id=4, kind="other", r=16,h=56 },

  dm_player     = { id=11, kind="other", r=16,h=56 },
  teleport_spot = { id=14, kind="other", r=16,h=56 },

  --- MONSTERS ---

  commonus      = { id=3004,kind="monster", r=20,h=56 },
  bipedicus     = { id=9,   kind="monster", r=20,h=56 },
  armored_biped = { id=3001,kind="monster", r=20,h=56 },
  cycloptis     = { id=3002,kind="monster", r=30,h=56 },

  --- BOSSES ---

  Flembrane = { id=3003,kind="monster", r=44,h=100 },

  --- PICKUPS ---

  redcard    = { id=13, kind="pickup", r=20,h=16, pass=true },
  yellowcard = { id=6,  kind="pickup", r=20,h=16, pass=true },
  bluecard   = { id=5,  kind="pickup", r=20,h=16, pass=true },

  largezorcher     = { id=2001, kind="pickup", r=20,h=16, pass=true },
  rapidzorcher     = { id=2002, kind="pickup", r=20,h=16, pass=true },
  zorchpropulsor   = { id=2003, kind="pickup", r=20,h=16, pass=true },
  phasingzorcher   = { id=2004, kind="pickup", r=20,h=16, pass=true },
  superbootspork   = { id=2005, kind="pickup", r=20,h=16, pass=true },
  lazdevice        = { id=2006, kind="pickup", r=20,h=16, pass=true },

  zorchpack      = { id=   8, kind="pickup", r=20,h=16, pass=true },
  slimeproofsuit = { id=2025, kind="pickup", r=20,h=60, pass=true },
  allmap         = { id=2026, kind="pickup", r=20,h=16, pass=true },

  water       = { id=2014, kind="pickup", r=20,h=16, pass=true },
  fruit       = { id=2011, kind="pickup", r=20,h=16, pass=true },
  vegetables  = { id=2012, kind="pickup", r=20,h=16, pass=true },
  supercharge = { id=2013, kind="pickup", r=20,h=16, pass=true },

  repellent  = { id=2015, kind="pickup", r=20,h=16, pass=true },
  armor      = { id=2018, kind="pickup", r=20,h=16, pass=true },
  superarmor = { id=2019, kind="pickup", r=20,h=16, pass=true },

  minizorch          = { id=2007, kind="pickup", r=20,h=16, pass=true },
  minizorchpack      = { id=2048, kind="pickup", r=20,h=16, pass=true },
  largezorch         = { id=2008, kind="pickup", r=20,h=16, pass=true },
  largezorchpack     = { id=2049, kind="pickup", r=20,h=16, pass=true },
  propulsorzorch     = { id=2010, kind="pickup", r=20,h=16, pass=true },
  propulsorzorchpack = { id=2046, kind="pickup", r=20,h=16, pass=true },
  phasingzorch       = { id=2047, kind="pickup", r=20,h=16, pass=true },
  phasingzorchpack   = { id=  17, kind="pickup", r=20,h=16, pass=true },

  --- SCENERY ---

  -- TECH --

  landinglight = { id=2028,kind="scenery", r=16,h=35, light=255 },
  lightcolumn  = { id=55,  kind="scenery", r=16,h=86, light=255 },

  flagpole  = { id=37, kind="scenery", r=16,h=128 },
  gastank   = { id=35, kind="scenery", r=16,h=36 },
  spaceship = { id=48, kind="scenery", r=16,h=52 },

  chemicalburner = { id=41, kind="scenery", r=16,h=25 },
  chemicalflask  = { id=34, kind="scenery", r=16,h=16, pass=true },
  submergedplant = { id=31, kind="scenery", r=16,h=42 },

  -- ARBORETUM --

  appletree   = { id=47, kind="scenery", r=16,h=92,  add_mode="island" },
  bananatree  = { id=54, kind="scenery", r=31,h=108, add_mode="island" },
  orangetree  = { id=43, kind="scenery", r=16,h=92,  add_mode="island" },
  tallflower  = { id=28, kind="scenery", r=20,h=25,  add_mode="island" },
  tallflower2 = { id=25, kind="scenery", r=20,h=25,  add_mode="island" },

  -- CAVE --

  column        = { id=32, kind="scenery", r=16,h=128 },
  stalagmite    = { id=30, kind="scenery", r=16,h=60 },
  minecart      = { id=33, kind="scenery", r=16,h=30 },
  slimefountain = { id=44, kind="scenery", r=16,h=48 },

  -- MISC --
 
  civilian1 = { id=45, kind="scenery", r=16,h=54 },
  civilian2 = { id=56, kind="scenery", r=16,h=54 },
  civilian3 = { id=57, kind="scenery", r=16,h=48 },
}


----------------------------------------------------------------

CHEX.MATERIALS =
{
  -- special materials --
  _ERROR = { t="SHAWN2", f="FLOOR0_5" },
  _SKY   = { t="SHAWN2", f="F_SKY1" },

  -- textures --

  FIREMAG1 = { t="FIREMAG1", f="NUKAGE1" },
  STARG3   = { t="STARG3",  f="FLOOR0_5" },
  STARTAN1 = { t="STARTAN1", f="FLOOR0_5" },

  -- flats --

  CEIL4_1  = { t="STARG3", f="CEIL4_1" },
  FLOOR0_5 = { t="STARG3", f="FLOOR0_5" },
  NUKAGE1  = { t="STARTAN1", f="NUKAGE1" },
  LAVA1    = { t="STARTAN1", f="LAVA1" },

}

CHEX.SANITY_MAP =
{
  --LAVA1    = "FWATER1",
  --FWATER1  = "BLOOD1",
  --BLOOD1   = "NUKAGE1",
  --NUKAGE1  = "LAVA1",
  --FIREMAG1 = "FIREMAG1",
  --GSTFONT1 = "GSTFONT1",
  --DOORBLU  = "DOORBLU",
  --DOORRED  = "DOORRED",
  --DOORYEL  = "DOORYEL",
  --BRNBIGL  = "BRNBIGL",
  --BRNBIGR  = "BRNBIGR",
  --BRNSMAL2 = "BRNSMAL2",
  --STEP1    = "STEP2",
  --STEP2    = "STEP4",
  --STEP4    = "STEP1",
  
  NUKAGE1  = "LAVA1",
  LAVA1    = "NUKAGE1",
  FIREMAG1 = "FIREMAG1",
}

CHEX.LIFTS =
{
  slow = { kind=62,  walk=88  },
  fast = { kind=123, walk=120 },
}

----------------------------------------------------------------

CHEX.LIQUIDS =
{
  -- "blood", "nukage" and "lava" all look similar (like green slime) but do different damage
  --water  = { floor="FWATER1", wall="GSTFONT1" },
  --blood  = { floor="BLOOD1", wall="FIREMAG1", sec_kind=7 },
  nukage = { floor="NUKAGE1", wall="FIREMAG1", sec_kind=5 },
  lava   = { floor="LAVA1", wall="FIREMAG1", sec_kind=16, add_light=64 },
}

CHEX.COMBOS =
{
  BROWN =
  {
    wall = "STARG3",
  },

  BROWN2 = 
  {
    outdoor = true,
    wall = "STARTAN1",
    floor = "FLOOR0_5",
    ceil = "CEIL4_1",
  },
}

CHEX.ROOMS =
{
}

CHEX.SUB_THEMES =
-- TECH, ARBORETUM and CAVE?
{
  TECH =
  {
    building =
    {
      BROWN=50,
    },

    floors =
    {
      FLOOR0_5=50,
    },

    ceilings =
    {
      CEIL4_1=50,
    },
    
    ground =
    {
      BROWN2=50,
    },
  }, -- TECH
}


------------------------------------------------------------

-- Monster list
-- ============

-- nearly all the settings below for monsters, weapons and items
-- are the same as doom.lua, except the probs for monsters

CHEX.MONSTERS =
{
  commonus =
  {
    prob=60,
    health=20, damage=4, attack="melee",
  },

  bipedicus =
  {
    prob=45,
    health=30, damage=10, attack="melee",
  },

  armored_biped =
  {
    prob=35, crazy_prob=65,
    health=60, damage=20, attack="missile",
  },

  cycloptis =
  {
    prob=30,
    health=150, damage=25, attack="melee",
    weap_prefs={ zorchpropulsor=0.5 },
  },

  -- only used in E1M5, and is stationary (wall monster, with level exit behind it)

  Flembrane =
  {
    health=1000, damage=45, attack="missile",
    weap_prefs={ lazdevice=3.0 },
  },
}


-- Weapon list
-- ===========

CHEX.WEAPONS =
{
  bootspoon =
  {
    rate=1.5, damage=10, attack="melee",
  },

  superbootspork =
  {
    pref=3, add_prob=2, start_prob=1,
    rate=8.7, damage=10, attack="melee",
  },

  minizorcher =
  {
    pref=5,
    rate=1.8, damage=10, attack="hitscan",
    ammo="bullet", per=1,
  },

  rapidzorcher =
  {
    pref=70, add_prob=35, start_prob=40,
    rate=8.5, damage=10, attack="hitscan",
    ammo="bullet", per=1,
    give={ {ammo="bullet",count=20} },
  },

  largezorcher =
  {
    pref=70, add_prob=10, start_prob=60,
    rate=0.9, damage=70, attack="hitscan", splash={ 0,10 },
    ammo="shell", per=1,
    give={ {ammo="shell",count=8} },
  },

  zorchpropulsor =
  {
    pref=50, add_prob=25, start_prob=10,
    rate=1.7, damage=80, attack="missile", splash={ 50,20,5 },
    ammo="rocket", per=1,
    give={ {ammo="rocket",count=2} },
  },

  phasingzorcher =
  {
    pref=90, add_prob=13, start_prob=5,
    rate=11, damage=20, attack="missile",
    ammo="cell", per=1,
    give={ {ammo="cell",count=40} },
  },

  lazdevice =
  {
    pref=30, add_prob=30, start_prob=0.2, rarity=4,
    rate=0.8, damage=300, attack="missile", splash={60,45,30,30,20,10},
    ammo="cell", per=40,
    give={ {ammo="cell",count=40} },
  },
}


-- Pickup List
-- ===========

CHEX.PICKUPS =
{
  -- HEALTH --

  water =
  {
    prob=20, cluster={ 4,7 },
    give={ {health=1} },
  },

  fruit =
  {
    prob=60, cluster={ 2,5 },
    give={ {health=10} },
  },

  vegetables =
  {
    prob=100, cluster={ 1,3 },
    give={ {health=25} },
  },

  supercharge =
  {
    prob=3, big_item=true,
    give={ {health=150} },
  },

  -- ARMOR --

  repellent =
  {
    prob=10, armor=true, cluster={ 4,7 },
    give={ {health=1} },
  },

  armor =
  {
    prob=5, armor=true, big_item=true,
    give={ {health=30} },
  },

  superarmor =
  {
    prob=2, armor=true, big_item=true,
    give={ {health=90} },
  },

  -- AMMO --

  minizorch =
  {
    prob=10, cluster={ 2,5 },
    give={ {ammo="bullet",count=10} },
  },

  minizorchpack =
  {
    prob=40, cluster={ 1,3 },
    give={ {ammo="bullet", count=50} },
  },

  largezorch =
  {
    prob=20, cluster={ 2,5 },
    give={ {ammo="shell",count=4} },
  },

  largezorchpack =
  {
    prob=40, cluster={ 1,3 },
    give={ {ammo="shell",count=20} },
  },

  propulsorzorch =
  {
    prob=10, cluster={ 4,7 },
    give={ {ammo="rocket",count=1} },
  },

  propulsorzorchpack =
  {
    prob=40, cluster={ 1,3 },
    give={ {ammo="rocket",count=5} },
  },

  phasingzorch =
  {
    prob=20, cluster={ 2,5 },
    give={ {ammo="cell",count=20} },
  },

  phasingzorchpack =
  {
    prob=40, cluster={ 1,2 },
    give={ {ammo="cell",count=100} },
  },
}


CHEX.PLAYER_MODEL =
{
  chexguy =
  {
    stats   = { health=0, bullet=0, shell=0, rocket=0, cell=0 },
    weapons = { minizorcher=1, bootspoon=1 },
  }
}


------------------------------------------------------------

CHEX.EPISODES =
-- Chex Quest only has one episode of five levels
{
}

function CHEX.setup()
 -- TODO
end

function CHEX.get_levels()
  local EP_NUM  = 1
  local MAP_NUM = 1

  if OB_CONFIG.length == "few"     then MAP_NUM = 2 end
  if OB_CONFIG.length == "episode" then MAP_NUM = 5 end
  if OB_CONFIG.length == "full"    then MAP_NUM = 5 ; EP_NUM = 1 end

  for episode = 1,EP_NUM do
    for map = 1,MAP_NUM do

      local LEV =
      {
        name  = string.format("E%dM%d", episode, map),
        patch = string.format("WILV%d%d", episode-1, map-1),

        episode  = episode,
        ep_along = map / MAP_NUM,
        ep_info  = { },

        theme_ref = "TECH",
        name_theme = "TECH",

        key_list = { "foo" },
        switch_list = { "foo" },
        bar_list = { "foo" },
      }

      table.insert(GAME.all_levels, LEV)
    end -- for map

  end -- for episode
end

function CHEX.begin_level()
  -- set the description here
  if not LEVEL.description and LEVEL.name_theme then
    LEVEL.description = Naming.grab_one(LEVEL.name_theme)
  end
end


------------------------------------------------------------

OB_THEMES["chex_tech"] =
{
  ref = "TECH",
  label = "Tech",
  for_games = { chex=1 },
}

UNFINISHED["chex_arboretum"] =
{
  ref = "ARBORETUM",
  label = "Arboretum",
  for_games = { chex=1 },
}

UNFINISHED["chex_cave"] =
{
  ref = "CAVE",
  label = "Cave",
  for_games = { chex=1 },
}


------------------------------------------------------------

UNFINISHED["chex"] =
{
  label = "Chex Quest",

  setup_func        = CHEX.setup,
  levels_start_func = CHEX.get_levels,
  begin_level_func  = CHEX.begin_level,

  param =
  {
    format = "doom",

    rails = true,
    switches = true,
    liquids = true,
    teleporters = true,
    infighting = true,

    custom_flats = true,

    seed_size = 256,

    max_name_length = 28,

    skip_monsters = { 10,35 },

    time_factor   = 1.0,
    damage_factor = 1.0,
    ammo_factor   = 0.8,
    health_factor = 0.7,
  },

  tables =
  {
    "player_model", CHEX.PLAYER_MODEL,
    "things",       CHEX.THINGS,
    "materials",    CHEX.MATERIALS,
    "sanity_map",   CHEX.SANITY_MAP,
    "lifts",        CHEX.LIFTS,
    "liquids",      CHEX.LIQUIDS,
    "combos",       CHEX.COMBOS,
    "rooms",        CHEX.ROOMS,
    "themes",       CHEX.SUB_THEMES,
    "monsters",     CHEX.MONSTERS,
    "weapons",      CHEX.WEAPONS,
    "pickups",      CHEX.PICKUPS,
  },
}
