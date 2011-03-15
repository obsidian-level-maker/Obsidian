----------------------------------------------------------------
-- GAME DEF : Amulets & Armor
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2011 leilei
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

AMULETS = { }

AMULETS.ENTITIES =
{
  --- PLAYERS ---

  player1 = { id=1, kind="other", r=16,h=56 },
  player2 = { id=2, kind="other", r=16,h=56 },
  player3 = { id=3, kind="other", r=16,h=56 },
  player4 = { id=4, kind="other", r=16,h=56 },

  dm_player     = { id=11, kind="other", r=16,h=56 },
  teleport_spot = { id=14, kind="other", r=16,h=56 },
  
  --- ANIMALS ---
  elk     = { id=1016, kind="monster", r=20,h=56 },
  wolf    = { id=1017, kind="monster", r=20,h=56 },
---  wolf2 = { id=1034, kind="monster", r=20,h=56 },

  --- MONSTERS ---

  sorcerer       = { id=1002, kind="monster", r=20,h=56 },
  deathangel     = { id=1003, kind="monster", r=20,h=56 },

  prophet        = { id=1006, kind="monster", r=20,h=56 },
  gargoyle       = { id=1007, kind="monster", r=20,h=56 },
  knight1           = { id=1008, kind="monster", r=20,h=56 },
  footman1       = { id=1009, kind="monster", r=20,h=56 },
---  god           = { id=1010, kind="monster", r=20,h=56 },
  barbarian1     = { id=1011, kind="monster", r=20,h=56 },
  banshee        = { id=1012, kind="monster", r=20,h=56 },
  mercenary      = { id=1014, kind="monster", r=20,h=56 },
  nimrud         = { id=1015, kind="monster", r=20,h=56 },
  elfguardian    = { id=1018, kind="monster", r=20,h=56 },
  druid            = { id=1019, kind="monster", r=20,h=56 },
  deathpriest    = { id=1020, kind="monster", r=20,h=56 },
  serpent = { id=1022, kind="monster", r=20,h=56 },
  griffon = { id=1023, kind="monster", r=20,h=56 },
---  dragon = { id=1024, kind="monster", r=20,h=56 },
  destroyer = { id=1025, kind="monster", r=20,h=56 },
  boulder = { id=1026, kind="monster", r=20,h=56 },

  skeleton = { id=1033, kind="monster", r=20,h=56 },
  deathknight = { id=1035, kind="monster", r=20,h=56 },
  elmore = { id=1036, kind="monster", r=20,h=56 },
 ---  = { id=, kind="monster", r=20,h=56 },
   
  --- BOSSES ---

  wyvern         = { id=1005, kind="monster", r=10,h=5644 },
  reddragon      = { id=1021, kind="monster", r=10,h=5644 },
  exiguus = { id=1032, kind="monster", r=20,h=564 },

  --- PICKUPS ---




  --- WEAPONS ---

  --- Wood - dmg 1 ---
  dagger_wood   = { id=4296, kind="pickup", r=20,h=16, pass=true },
  mace_wood     = { id=4297, kind="pickup", r=20,h=16, pass=true },
  staff_wood    = { id=4298, kind="pickup", r=20,h=16, pass=true },
  shtsword_wood = { id=4299, kind="pickup", r=20,h=16, pass=true },
  lngsword_wood = { id=4300, kind="pickup", r=20,h=16, pass=true },
  axe_wood      = { id=4301, kind="pickup", r=20,h=16, pass=true },
  bolt_wood     = { id=4302, kind="pickup", r=20,h=16, pass=true },


  potion = { id=811, kind="pickup", r=20,h=16, pass=true },

  --- SCENERY ---
  jaw = { id=59, kind="scenery", r=20,h=16, pass=true },
}


AMULETS.PARAMETERS =
{
  rails = true,
  switches = true,
  liquids = true,
  teleporters = true,
  raising_start = true,
  light_brushes = true,

  -- NOTE: no infighting at all

  custom_flats = true,

  max_name_length = 28,

  skip_monsters = { 26,40 },

  time_factor   = 1.0,
  damage_factor = 1.0,
  ammo_factor   = 0.8,
  health_factor = 0.7,
}


----------------------------------------------------------------

AMULETS.MATERIALS =
{
  -- FIXME this is all just temporary

  -- special materials --
  _ERROR = { t="DGITEX14", f="DGITEX14" },
  _SKY   = { t="GRAYTALL", f="F_SKY1" },

  -- textures --

  BROWNGRN = { t="BROWNGRN", f="FLAT1" },
  FIREMAG1 = { t="FIREMAG1", f="NUKAGE1", sane=1 },
  STARG3   = { t="STARG3",   f="FLAT1" },

  -- flats --

  FLAT1   = { t="BROWNGRN", f="FLAT1" },
  FLAT5_6 = { t="BROWNGRN", f="FLAT5_6" },
  LAVA1   = { t="BROWNGRN", f="LAVA1",   sane=1 },
  NUKAGE1 = { t="BROWNGRN", f="NUKAGE1", sane=1 },
}


AMULETS.LIFTS =
{
  slow = { kind=62,  walk=88  },
  fast = { kind=123, walk=120 },
}


AMULETS.SKINS =
{
  ----| STARTS |----

  Start_ledge =
  {
    _prefab = "START_LEDGE",
    _where  = "edge",
    _long   = 192,
    _deep   =  64,

    wall = "CRACKLE2",
  },


  ----| EXITS |----

  Exit_switch =
  {
    _prefab = "WALL_SWITCH",
    _where  = "edge",
    _long   = 192,
    _deep   = 64,

    wall = "EXITSTON",

    switch="SW1HOT", line_kind=11, x_offset=0, y_offset=0,
  },


  ----| ARCHES |----

  Arch1 =
  {
    _prefab = "ARCH",
    _where  = "edge",
    _long   = 192,
    _deep   = 64,
  },


  ---| FLOORS |---

  H_Stair6 =
  {
    _prefab = "H_STAIR_6",

    step = "STEP1",
  },


}


----------------------------------------------------------------

AMULETS.LIQUIDS =
{
  -- "blood", "nukage" and "lava" all look similar (like green slime) but do different damage
  --water  = { floor="FWATER1", wall="GSTFONT1" },
  --blood  = { floor="BLOOD1", wall="FIREMAG1", sec_kind=7 },
  nukage = { floor="NUKAGE1", wall="FIREMAG1", sec_kind=5 },
  lava   = { floor="LAVA1", wall="FIREMAG1", sec_kind=16, add_light=64 },
}

AMULETS.ROOMS =
{
}

AMULETS.SUB_THEMES =
{
  amulets_tech1 =
  {
    prob=50,

    building_walls =
    {
      BROWNGRN=25, STARG3=25,
    },

    building_floors =
    {
      FLAT1=50,
    },

    building_ceilings =
    {
      FLAT1=50,
    },

    courtyard_floors =
    {
      FLAT5_6=50,
    },

    starts = { Start_ledge = 50 },

    exits = { Exit_switch = 50 },

    arches = { Arch1 = 50 },

    floors = { H_Stair6 = 50 },

  }, -- TECH
}

------------------------------------------------------------

-- Monster list
-- ============

AMULETS.MONSTERS =
{
  barbarian1 =
  {
    prob=40,
    health=20, damage=4, attack="melee",
  },

}

-- Weapon list
-- ===========

AMULETS.WEAPONS =
{
 dagger_wood =
  {
    pref=70, add_prob=10, start_prob=60,
    rate=0.9, damage=11, attack="hitscan", splash={ 0,10 },
  },
}

-- Pickup List
-- ===========

AMULETS.PICKUPS =
{
  -- HEALTH --
  

  -- ARMOR --
}

AMULETS.PLAYER_MODEL =
{
  avatar =
  {
    stats   = { health=0 },
    weapons = { },
  }
}

------------------------------------------------------------

AMULETS.EPISODES =
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

function AMULETS.setup()
 -- nothing needed
end

function AMULETS.get_levels()
  local EP_NUM  = sel(OB_CONFIG.length == "full", 3, 1)
  local MAP_NUM = sel(OB_CONFIG.length == "single", 1, 5)

  if OB_CONFIG.length == "few" then MAP_NUM = 2 end

  for episode = 1,EP_NUM do
    local ep_info = AMULETS.EPISODES["episode" .. episode]
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
      }

      table.insert(GAME.all_levels, LEV)
    end -- for map

  end -- for episode
end

function AMULETS.begin_level()
  -- set the description here
  if not LEVEL.description and LEVEL.name_theme then
    LEVEL.description = Naming_grab_one(LEVEL.name_theme)
  end
end



------------------------------------------------------------

OB_GAMES["amulets"] =
{
  label = "Amulets & Armor",

  format = "doom",

  tables =
  {
    AMULETS
  },

  hooks =
  {
    setup        = AMULETS.setup,
    get_levels   = AMULETS.get_levels,
    begin_level  = AMULETS.begin_level,
  },
}

-- themes (TECH2 etc...): caves, spaceship (use flemkeys here)

OB_THEMES["amulets_tech"] =
{
  label = "Tech",
  for_games = { amulets=1 },

  name_theme = "TECH",
  mixed_prob = 50,
}

-- themes (CITY2 etc...): sewers, lodge {lots of trees 
-- and grassy / rocky terrain outdoors, wooden buildings)

UNFINISHED["amulets_city"] =
{
  label = "City",
  for_games = { amulets=1 },

  name_theme = "URBAN",
  mixed_prob = 50,
}

