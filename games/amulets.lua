----------------------------------------------------------------
-- GAME DEF : Amulets & Armor
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2011 leilei
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

AMULETS = { }

AMULETS.ENTITIES =
{
  --- PLAYERS ---

  player1 = { id=1, r=16, h=56 }
  player2 = { id=2, r=16, h=56 }
  player3 = { id=3, r=16, h=56 }
  player4 = { id=4, r=16, h=56 }

  dm_player     = { id=11 }
  teleport_spot = { id=14 }
  
  --- PICKUPS ---

  potion = { id=811 }

  --- SCENERY ---
  jaw = { id=59, r=20, h=16, pass=true }
}


AMULETS.PARAMETERS =
{
  -- FIXME THESE

  rails = true
  switches = true
  raising_start = true
  light_brushes = true

  custom_flats = true

  max_name_length = 28

  skip_monsters = { 26,40 }

  time_factor   = 1.0
  damage_factor = 1.0
  ammo_factor   = 0.8
  health_factor = 0.7
}


----------------------------------------------------------------

AMULETS.MATERIALS =
{
  -- FIXME this is all just temporary

  -- special materials --
  _ERROR = { t="DGITEX14", f="GRASS2" }
  _SKY   = { t="DGITEX14", f="F_SKY1" }

  -- textures --

  WALL1 = { t="T39", f="T39" }

  ROCK1 = { t="FART3", f="GRASS2" }

  -- flats --

  GRASS2 = { t="DGITEX30", f="GRASS2" }
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
  }


  ----| EXITS |----

  Exit_switch =
  {
    _prefab = "WALL_SWITCH",
    _where  = "edge",
    _long   = 192,
    _deep   = 64,

    wall = "EXITSTON",

    switch="SW1HOT", line_kind=11, x_offset=0, y_offset=0,
  }


  ----| ARCHES |----

  Arch1 =
  {
    _prefab = "ARCH",
    _where  = "edge",
    _long   = 192,
    _deep   = 64,
  }


  ---| FLOORS |---

  H_Stair6 =
  {
    _prefab = "H_STAIR_6",

    step = "STEP1",
  }


}


----------------------------------------------------------------

AMULETS.LIQUIDS =
{
  -- "blood", "nukage" and "lava" all look similar (like green slime) but do different damage
  --water  = { floor="FWATER1", wall="GSTFONT1" }
  --blood  = { floor="BLOOD1", wall="FIREMAG1", sec_kind=7 }
  nukage = { floor="NUKAGE1", wall="FIREMAG1", sec_kind=5 }
  lava   = { floor="LAVA1", wall="FIREMAG1", sec_kind=16, add_light=64 }
}


AMULETS.LEVEL_THEMES =
{
  amulets_city1 =
  {
    prob = 50

    building_walls =
    {
      WALL1=50,
    }

    building_floors =
    {
      WALL1=50,
    }

    building_ceilings =
    {
      WALL1=50,
    }

    courtyard_floors =
    {
      ROCK1=50,
    }

    starts = { Start_ledge = 50 }

    exits = { Exit_switch = 50 }

    arches = { Arch1 = 50 }

    floors = { H_Stair6 = 50 }

  }, -- CITY
}


------------------------------------------------------------

-- Monster list
-- ============

AMULETS.MONSTERS =
{
  barbarian1 =
  {
    id = 1011
    r = 32
    h = 64
    prob = 40
    health = 20
    attack = "melee"
    damage = 4
  } 

--[[ FIXME

  elk     = { id=1016, kind="monster", r=20,h=56 }
  wolf    = { id=1017, kind="monster", r=20,h=56 }
---  wolf2 = { id=1034, kind="monster", r=20,h=56 }

  sorcerer       = { id=1002, kind="monster", r=20,h=56 }
  deathangel     = { id=1003, kind="monster", r=20,h=56 }

  prophet        = { id=1006, kind="monster", r=20,h=56 }
  gargoyle       = { id=1007, kind="monster", r=20,h=56 }
  knight1           = { id=1008, kind="monster", r=20,h=56 }
  footman1       = { id=1009, kind="monster", r=20,h=56 }
---  god           = { id=1010, kind="monster", r=20,h=56 }
  barbarian1     = { id=1011, kind="monster", r=20,h=56 }
  banshee        = { id=1012, kind="monster", r=20,h=56 }
  mercenary      = { id=1014, kind="monster", r=20,h=56 }
  nimrud         = { id=1015, kind="monster", r=20,h=56 }
  elfguardian    = { id=1018, kind="monster", r=20,h=56 }
  druid            = { id=1019, kind="monster", r=20,h=56 }
  deathpriest    = { id=1020, kind="monster", r=20,h=56 }
  serpent = { id=1022, kind="monster", r=20,h=56 }
  griffon = { id=1023, kind="monster", r=20,h=56 }
---  dragon = { id=1024, kind="monster", r=20,h=56 }
  destroyer = { id=1025, kind="monster", r=20,h=56 }
  boulder = { id=1026, kind="monster", r=20,h=56 }

  skeleton = { id=1033, kind="monster", r=20,h=56 }
  deathknight = { id=1035, kind="monster", r=20,h=56 }
  elmore = { id=1036, kind="monster", r=20,h=56 }
   
  --- BOSSES ---

  Wyvern     = { id=1005, kind="monster", r=10,h=5644 }
  Reddragon  = { id=1021, kind="monster", r=10,h=5644 }
  Exiguus = { id=1032, kind="monster", r=20,h=564 }

--]]
}

-- Weapon list
-- ===========

AMULETS.WEAPONS =
{
  --- Wood - dmg 1 ---

  dagger_wood =
  {
    id = 4296
    add_prob = 10
    start_prob = 60
    pref = 70
    attack = "hitscan"
    rate = 0.9
    damage = 11
    splash = { 0,10 }
  }

--[[ TODO
mace_wood     = { id=4297 }
staff_wood    = { id=4298 }
shtsword_wood = { id=4299 }
lngsword_wood = { id=4300 }
axe_wood      = { id=4301 }
bolt_wood     = { id=4302 }
--]]

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
    stats   = { health=0 }
    weapons = { }
  }
}


------------------------------------------------------------

AMULETS.EPISODES =
{
  -- these correspond to the seven quests

  episode1 =
  {
    theme = "CITY"
    sky_light = 0.75
    maps = { "l30", "l301", "l531", "l31", "l22" }
  }

  episode2 =
  {
    theme = "CITY"
    sky_light = 0.75
    maps = { "l25", "l20", "l60" }
  }

  episode3 =
  {
    theme = "CITY"
    sky_light = 0.75
    maps = { "l64", "l65", "l34", "l151", "l152", "l153" }
  }

  episode4 =
  {
    theme = "CITY"
    sky_light = 0.75
    maps = { "l231", "l75", "l10", "l12" }
  }

  episode5 =
  {
    theme = "CITY"
    sky_light = 0.75
    maps = { "l51", "l52", "l41", "l44" }
  }

  episode6 =
  {
    theme = "CITY"
    sky_light = 0.75
    maps = { "l74", "l73", "l72" }
  }

  episode7 =
  {
    theme = "CITY"
    sky_light = 0.75
    maps = { "l32", "l71", "l70", "l61", "l40" }
  }
}


function AMULETS.setup()
 -- nothing needed
end


function AMULETS.get_levels()
  local EP_NUM  = (OB_CONFIG.length == "full"   ? 7 ; 1)
  local MAP_NUM = (OB_CONFIG.length == "single" ? 1 ; 5)

  for episode = 1,EP_NUM do
    local ep_info = AMULETS.EPISODES["episode" .. episode]
    assert(ep_info)

    local MAP_NUM = #ep_info.maps

    if OB_CONFIG.length == "single" then MAP_NUM = 1 end
    if OB_CONFIG.length == "few"    then MAP_NUM = 2 end

    for map = 1,MAP_NUM do
      local ep_along = map / 6

      if OB_CONFIG.length == "single" then
        ep_along = 0.5
      elseif OB_CONFIG.length == "few" then
        ep_along = map / 4
      end

      local LEV =
      {
        name = string.format("E%dM%d", episode, map)
        wad_name = ep_info.maps[map]

        episode  = episode
        ep_along = ep_along
        ep_info  = ep_info
      }

      table.insert(GAME.levels, LEV)
    end -- for map

  end -- for episode
end


------------------------------------------------------------

UNFINISHED["amulets"] =
{
  label = "Amulets & Armor"

  format = "doom"

  tables =
  {
    AMULETS
  }

  hooks =
  {
    setup      = AMULETS.setup
    get_levels = AMULETS.get_levels
  }
}

OB_THEMES["amulets_city"] =
{
  label = "City"
  for_games = { amulets=1 }
  name_theme = "URBAN"
  mixed_prob = 50
}

