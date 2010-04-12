----------------------------------------------------------------
-- GAME DEF : Chex Quest 3
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

CHEX3_THINGS =
{
  --- PLAYERS ---

  player1 = { id=1, kind="other", r=16,h=56 },
  player2 = { id=2, kind="other", r=16,h=56 },
  player3 = { id=3, kind="other", r=16,h=56 },
  player4 = { id=4, kind="other", r=16,h=56 },

  dm_player     = { id=11, kind="other", r=16,h=56 },
  teleport_spot = { id=14, kind="other", r=16,h=56 },

  --- MONSTERS ---

  commonus       = { id=3004, kind="monster", r=20,h=56 },
  bipedicus      = { id=9,    kind="monster", r=20,h=56 },
  armored_biped  = { id=3001, kind="monster", r=20,h=56 },
  stridicus      = { id=3002, kind="monster", r=30,h=56 },
  cycloptis      = { id=58  , kind="monster", r=30,h=56 },
  flemmine       = { id=3006, kind="monster", r=16,h=56 },
  supercycloptis = { id=3005, kind="monster", r=31,h=56 },
  maximus        = { id=3003, kind="monster", r=24,h=64 },
  larva          = { id=9050, kind="monster", r=30,h=56 },
  quadrumpus     = { id=9057, kind="monster", r=20,h=56 },

  --- BOSSES ---

  Flembrane      = { id=69, kind="monster", r=64,h=64 },
  Snotfolus      = { id=16, kind="monster", r=40,h=110 },
  Flembomination = { id=7,  kind="monster", r=100,h=100 },

  --- PICKUPS ---

  redcard       = { id=13, kind="pickup", r=20,h=16, pass=true },
  yellowcard    = { id=6,  kind="pickup", r=20,h=16, pass=true },
  bluecard      = { id=5,  kind="pickup", r=20,h=16, pass=true },
  redflemkey    = { id=38, kind="pickup", r=20,h=16, pass=true },
  yellowflemkey = { id=39, kind="pickup", r=20,h=16, pass=true },
  blueflemkey   = { id=40, kind="pickup", r=20,h=16, pass=true },

  largezorcher   = { id=2001, kind="pickup", r=20,h=16, pass=true },
  rapidzorcher   = { id=2002, kind="pickup", r=20,h=16, pass=true },
  zorchpropulsor = { id=2003, kind="pickup", r=20,h=16, pass=true },
  phasingzorcher = { id=2004, kind="pickup", r=20,h=16, pass=true },
  superbootspork = { id=2005, kind="pickup", r=20,h=16, pass=true },
  lazdevice      = { id=2006, kind="pickup", r=20,h=16, pass=true },

  zorchpack      = { id=   8, kind="pickup", r=20,h=16, pass=true },
  slimeproofsuit = { id=2025, kind="pickup", r=20,h=60, pass=true },
  allmap         = { id=2026, kind="pickup", r=20,h=16, pass=true },
  goggles        = { id=2045, kind="pickup", r=20,h=16, pass=true },

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

  -- Doom barrel, named the same for compatibility
  barrel = { id=2035, kind="scenery", r=15,h=60 },

  candlestick   = { id=34,  kind="scenery", r=20,h=18,  light=255 },
  landinglight  = { id=2028,kind="scenery", r=16,h=35,  light=255 },
  streetlight   = { id=35,  kind="scenery", r=16,h=128, light=255 },
  bluetorch_sm  = { id=55,  kind="scenery", r=16,h=26,  light=255 },
  greentorch    = { id=45,  kind="scenery", r=16,h=68,  light=255 },
  greentorch_sm = { id=56,  kind="scenery", r=16,h=55,  light=255 },
  redtorch      = { id=46,  kind="scenery", r=16,h=68,  light=255 },
  redtorch_sm   = { id=57,  kind="scenery", r=16,h=26,  light=255 },
  
  beaker         = { id=80, kind="scenery", r=20,h=64, pass=true },
  chemicalburner = { id=41, kind="scenery", r=16,h=25 },
  flagpole       = { id=37, kind="scenery", r=16,h=128 },
  globestand     = { id=25, kind="scenery", r=16,h=64 },
  labcoil        = { id=42, kind="scenery", r=16,h=90 },
  mappointlight  = { id=85, kind="scenery", r=16,h=75 },
  modelrocket    = { id=18, kind="scenery", r=20,h=106 },
  monitor        = { id=29, kind="scenery", r=16,h=51 },
  oxygentank     = { id=36, kind="scenery", r=16,h=40 },
  propbarrel     = { id=32, kind="scenery", r=16,h=36 },
  radardish      = { id=19, kind="scenery", r=20,h=121 },
  spaceship      = { id=54, kind="scenery", r=32,h=58 },
  stool          = { id=49, kind="scenery", r=16,h=41 },
  techpillar     = { id=48, kind="scenery", r=16,h=83 },
  telephone      = { id=28, kind="scenery", r=16,h=26, pass=true },

  appletree  = { id=9060, kind="scenery", r=20,h=64 },
  bananatree = { id=9058, kind="scenery", r=20,h=64 },
  beechtree  = { id=9059, kind="scenery", r=20,h=64 },
  orangetree = { id=9061, kind="scenery", r=20,h=64 },
  pinetree   = { id=30,   kind="scenery", r=16,h=130 },
  torchtree  = { id=43,   kind="scenery", r=16,h=128 },

  captive1   = { id=70, kind="scenery", r=16,h=65 },
  captive2   = { id=26, kind="scenery", r=16,h=65 },
  captive3   = { id=52, kind="scenery", r=16,h=65 },
  dinerchef  = { id=23, kind="scenery", r=20,h=64 },
  dinertable = { id=22, kind="scenery", r=20,h=64 },
  
  bigbowl    = { id=51, kind="scenery", r=40,h=64 },
  greyrock   = { id=31, kind="scenery", r=16,h=36 },
  hydroplant = { id=50, kind="scenery", r=16,h=45 },
  slimeyurn  = { id=86, kind="scenery", r=16,h=83 },
  
  cavebat      = { id=63, kind="scenery", r=16,h=64, pass=true, ceil=true },
  ceilingslime = { id=60, kind="scenery", r=16,h=68, pass=true, ceil=true },
  hangplant1   = { id=59, kind="scenery", r=20,h=64, pass=true, ceil=true },
  hangplant2   = { id=61, kind="scenery", r=20,h=64, pass=true, ceil=true },
  hangpots     = { id=62, kind="scenery", r=20,h=64, pass=true, ceil=true },
  
  slimeymeteor = { id=27, kind="scenery", r=16,h=30 },
  
  cavepillar  = { id=73, kind="scenery", r=16,h=128 },
  minecart    = { id=53, kind="scenery", r=16,h=64 },
  stalagmite  = { id=74, kind="scenery", r=16,h=64 },
  stalagtite  = { id=47, kind="scenery", r=16,h=130 },
  stalagtite2 = { id=75, kind="scenery", r=16,h=64, pass=true, ceil=true },
  dinosaur1   = { id=76, kind="scenery", r=60,h=120 },
  dinosaur2   = { id=77, kind="scenery", r=60,h=120 },
  flower1     = { id=78, kind="scenery", r=16,h=64, pass=true },
  flower2     = { id=79, kind="scenery", r=16,h=64, pass=true },
  
  smallbush     = { id=81,   kind="scenery", r=20,h=4, pass=true },
  statue_david  = { id=9051, kind="scenery", r=20,h=64 },
  statue_think  = { id=9052, kind="scenery", r=20,h=64 },
  statue_ramses = { id=9053, kind="scenery", r=20,h=64 },
  statue_tut    = { id=9054, kind="scenery", r=20,h=64 },
  statue_chex   = { id=9055, kind="scenery", r=20,h=64 },
  statue_spoon  = { id=9056, kind="scenery", r=60,h=64 },
  
  slimefountain = { id=44, kind="scenery", r=16,h=48 },

}

----------------------------------------------------------------

CHEX3_MATERIALS =
{
  -- FIXME this is all just temporary

  -- special materials --
  _ERROR = { t="GRAYTALL", f="FLOOR0_6" },
  _SKY   = { t="GRAYTALL", f="F_SKY1" },

  -- textures --

  BROWNGRN = { t="BROWNGRN", f="FLAT1" },
  FIREMAG1 = { t="FIREMAG1", f="NUKAGE1" },
  STARG3   = { t="STARG3",   f="FLAT1" },

  -- flats --

  FLAT1   = { t="BROWNGRN", f="FLAT1" },
  FLAT5_6 = { t="BROWNGRN", f="FLAT5_6" },
  LAVA1   = { t="BROWNGRN", f="LAVA1" },
  NUKAGE1 = { t="BROWNGRN", f="NUKAGE1" },
}

CHEX3_SANITY_MAP =
{ 
  NUKAGE1  = "LAVA1",
  LAVA1    = "NUKAGE1",
  FIREMAG1 = "FIREMAG1",
}

CHEX3_LIFTS =
{
  slow = { kind=62,  walk=88  },
  fast = { kind=123, walk=120 },
}

----------------------------------------------------------------

CHEX3_LIQUIDS =
{
  -- "blood", "nukage" and "lava" all look similar (like green slime) but do different damage
  --water  = { floor="FWATER1", wall="GSTFONT1" },
  --blood  = { floor="BLOOD1", wall="FIREMAG1", sec_kind=7 },
  nukage = { floor="NUKAGE1", wall="FIREMAG1", sec_kind=5 },
  lava   = { floor="LAVA1", wall="FIREMAG1", sec_kind=16, add_light=64 },
}

CHEX3_ROOMS =
{
}

CHEX3_SUB_THEMES =
{
  chex3_tech1 =
  {
    prob=50,

    building =
    {
      walls =
      {
        BROWNGRN=25, STARG3=25,
      },
      floors =
      {
        FLAT1=50,
      },
      ceilings =
      {
        FLAT1=50,
      },
    },

    courtyard =
    {
      floors =
      {
        FLAT5_6=50,
      },
    },

  }, -- TECH
}

------------------------------------------------------------

-- Monster list
-- ============

CHEX3_MONSTERS =
{
  commonus =
  {
    prob=40,
    health=20, damage=4, attack="melee",
  },

  bipedicus =
  {
    prob=50,
    health=30, damage=10, attack="melee",
  },

  armored_biped =
  {
    prob=60,
    health=60, damage=20, attack="missile",
  },

  quadrumpus =
  {
    replaces="armored_biped", replace_prob=30, crazy_prob=25,
    health=60, damage=20, attack="missile",
  },

  flemmine =
  {
    prob=20,
    health=100, damage=7, attack="melee",
    density=0.7, float=true,
  },

  cycloptis =
  {
    prob=35,
    health=150, damage=25, attack="melee",
  },

  larva =
  {
    replaces="cycloptis", replace_prob=25, crazy_prob=25,
    health=100, damage=25, attack="melee",
  },

  stridicus =
  {
    prob=20,
    health=225, damage=25, attack="melee",
    density=0.7,
  },

  supercycloptis =
  {
    prob=30,
    health=400, damage=35, attack="missile",
    density=0.5, float=true,
  },

  maximus =
  {
    prob=15, skip_prob=100,
    health=1000, damage=45, attack="missile",
    density=0.3,
    weap_prefs={ lazdevice=3.0 },
  },

  -- BOSSES --

  -- Flembrane is a special case (stationary wall monster,
  -- with level exit behind it), and is not used in
  -- normal levels

  Flembrane =
  {
    health=1000, damage=45, attack="missile",
    weap_prefs={ lazdevice=3.0 },
  },

  Snotfolus =
  {
    prob=5, crazy_prob=10, skip_prob=300,
    health=4000, damage=135, attack="missile",
    density=0.1,
    weap_prefs={ lazdevice=5.0 },
  },

  Flembomination =
  {
    prob=5, crazy_prob=12, skip_prob=200,
    health=3000, damage=70, attack="missile",
    density=0.2,
    weap_prefs={ lazdevice=5.0 },
  },
}

-- Weapon list
-- ===========

CHEX3_WEAPONS =
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
    ammo="mzorch", per=1,
  },

  rapidzorcher =
  {
    pref=70, add_prob=35, start_prob=40,
    rate=8.5, damage=10, attack="hitscan",
    ammo="mzorch", per=1,
    give={ {ammo="mzorch",count=20} },
  },

  largezorcher =
  {
    pref=70, add_prob=10, start_prob=60,
    rate=0.9, damage=70, attack="hitscan", splash={ 0,10 },
    ammo="lzorch", per=1,
    give={ {ammo="lzorch",count=8} },
  },

  zorchpropulsor =
  {
    pref=50, add_prob=25, start_prob=10, rarity=2,
    rate=1.7, damage=80, attack="missile", splash={ 50,20,5 },
    ammo="propulsor", per=1,
    give={ {ammo="propulsor",count=2} },
  },

  phasingzorcher =
  {
    pref=90, add_prob=13, start_prob=5, rarity=2,
    rate=11, damage=20, attack="missile",
    ammo="phase", per=1,
    give={ {ammo="phase",count=40} },
  },

  lazdevice =
  {
    pref=30, add_prob=30, start_prob=0.2, rarity=5,
    rate=0.8, damage=300, attack="missile", splash={60,45,30,30,20,10},
    ammo="phase", per=40,
    give={ {ammo="phase",count=40} },
  },
}

-- Pickup List
-- ===========

CHEX3_PICKUPS =
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
    give={ {ammo="mzorch",count=10} },
  },

  minizorchpack =
  {
    prob=40, cluster={ 1,3 },
    give={ {ammo="mzorch", count=50} },
  },

  largezorch =
  {
    prob=20, cluster={ 2,5 },
    give={ {ammo="lzorch",count=4} },
  },

  largezorchpack =
  {
    prob=40, cluster={ 1,3 },
    give={ {ammo="lzorch",count=20} },
  },

  propulsorzorch =
  {
    prob=10, cluster={ 4,7 },
    give={ {ammo="propulsor",count=1} },
  },

  propulsorzorchpack =
  {
    prob=40, cluster={ 1,3 },
    give={ {ammo="propulsor",count=5} },
  },

  phasingzorch =
  {
    prob=20, cluster={ 2,5 },
    give={ {ammo="phase",count=20} },
  },

  phasingzorchpack =
  {
    prob=40, cluster={ 1,2 },
    give={ {ammo="phase",count=100} },
  },
}

CHEX3_PLAYER_MODEL =
{
  chexguy =
  {
    stats   = { health=0, mzorch=0, lzorch=0, propulsor=0, phase=0 },
    weapons = { minizorcher=1, bootspoon=1 },
  }
}

------------------------------------------------------------

CHEX3_EPISODES =
{
  episode1 =
  {
    theme = "TECH",
    sky_light = 0.75,
  },

-- E2M5 and E3M5 will exit when all bosses (Maximus, Flembomination 
-- and Snotfolus) are dead, so perhaps prevent an exit door or
-- switch from appearing if any of those appear in these levels?

  episode2 =
  {
    theme = "TECH",  -- FIXME will be CITY later
    sky_light = 0.75,
  },

  episode3 =
  {
    theme = "TECH",
    sky_light = 0.75,
  },
}

function CHEX3_setup()
 -- nothing needed
end

function CHEX3_get_levels()
  local EP_NUM  = sel(OB_CONFIG.length == "full", 3, 1)
  local MAP_NUM = sel(OB_CONFIG.length == "single", 1, 5)

  if OB_CONFIG.length == "few" then MAP_NUM = 2 end

  for episode = 1,EP_NUM do
    local ep_info = CHEX3_EPISODES["episode" .. episode]
    assert(ep_info)

    for map = 1,MAP_NUM do
      local ep_along = map / 6

      if OB_CONFIG.length == "single" then
        ep_along = 0.5
      elseif OB_CONFIG.length == "few" then
        ep_along = map / 4
      end

      local LEV =
      {
        name  = string.format("E%dM%d", episode, map),
        patch = string.format("WILV%d%d", episode-1, map-1),

        episode  = episode,
        ep_along = ep_along,
        ep_info  = ep_info,

        keys = { },
        switches = { },
        bars = { },
      }

      table.insert(GAME.all_levels, LEV)
    end -- for map

  end -- for episode
end

function CHEX3_begin_level()
  -- set the description here
  if not LEVEL.description and LEVEL.name_theme then
    LEVEL.description = Naming_grab_one(LEVEL.name_theme)
  end
end

------------------------------------------------------------

-- sub-themes (TECH2 etc...): caves, spaceship (use flemkeys here)

OB_THEMES["chex3_tech"] =
{
  label = "Tech",
  for_games = { chex3=1 },

  name_theme = "TECH",
  mixed_prob = 50,
}

-- sub-themes (CITY2 etc...): sewers, lodge {lots of trees 
-- and grassy / rocky terrain outdoors, wooden buildings)

UNFINISHED["chex3_city"] =
{
  label = "City",
  for_games = { chex3=1 },

  name_theme = "URBAN",
  mixed_prob = 50,
}

------------------------------------------------------------

UNFINISHED["chex3"] =
{
  label = "Chex Quest 3",

  hooks =
  {
    setup        = CHEX3_setup,
    levels_start = CHEX3_get_levels,
    begin_level  = CHEX3_begin_level,
  },

  param =
  {
    format = "doom",

    rails = true,
    switches = true,
    liquids = true,
    teleporters = true,
    raising_start = true,

    -- NOTE: no infighting at all

    custom_flats = true,

    seed_size = 256,

    max_name_length = 28,

    skip_monsters = { 26,40 },

    time_factor   = 1.0,
    damage_factor = 1.0,
    ammo_factor   = 0.8,
    health_factor = 0.7,
  },

  tables =
  {
    "things",       CHEX3_THINGS,
    "materials",    CHEX3_MATERIALS,
    "sanity_map",   CHEX3_SANITY_MAP,
    "lifts",        CHEX3_LIFTS,
    "liquids",      CHEX3_LIQUIDS,
    "rooms",        CHEX3_ROOMS,
    "themes",       CHEX3_SUB_THEMES,
    "monsters",     CHEX3_MONSTERS,
    "weapons",      CHEX3_WEAPONS,
    "pickups",      CHEX3_PICKUPS,
    "player_model", CHEX3_PLAYER_MODEL,
    "episodes",     CHEX3_EPISODES,
  },
}
