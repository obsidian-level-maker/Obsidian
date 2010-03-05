----------------------------------------------------------------
--  GAME DEFINITION : Duke Nukem 3D
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

NUKEM_THINGS =
{
  --- special stuff ---
  other1 = { id=1405, kind="player", r=20,h=56 },
  other2 = { id=1405, kind="player", r=20,h=56 },
  other3 = { id=1405, kind="player", r=20,h=56 },
  other4 = { id=1405, kind="player", r=20,h=56 },

  dm_other = { id=1405, kind="player", r=20,h=56 },

  --- monsters ---
  pig_cop = { id=2000, kind="monster", r=16,h=56 },

  -- bosses

  --- pickups ---
  k_yellow   = { id=80, kind="pickup", r=20,h=16, pass=true },

  --- scenery ---

}


----------------------------------------------------------------

NUKEM_MATERIALS =
{
  -- special materials --
  _ERROR = { t=1 },
  _SKY   = { t=89 },

  -- textures --

  BRICK1 = { t=723 },
  CAVE1  = { t=783 },

  -- flats --

  F_BRKTOP = { t=742 },
}


NUKEM_SANITY_MAP =
{
  -- FIXME
}


----------------------------------------------------------------


NUKEM_SUB_THEMES =
{
  CITY =
  {
    building =
    {
      walls = { BRICK1=50 },
      floors = { F_BRKTOP=50 },
      ceilings = { F_BRKTOP=50 },
    },

  }, -- CITY
}


------------------------------------------------------------

NUKEM_MONSTERS =
{
  -- FIXME : NUKEM_MONSTERS
}


NUKEM_WEAPONS =
{
  foot =
  {
    rate=1.5, damage=10, attack="melee",
  },

  -- FIXME : NUKEM_WEAPONS
}


NUKEM_PICKUPS =
{
  -- FIXME : NUKEM_PICKUPS
}


NUKEM_PLAYER_MODEL =
{
  duke =
  {
    stats = { health=0, bullet=0, missile=0,
              grenade=0, cell=0 },

    weapons = { foot=1 },
  }
}


------------------------------------------------------------


function Nukem_setup()
  -- nothing needed
end


function Nukem_get_levels()
  local EP_NUM  = 1
  local MAP_NUM = 1

  if OB_CONFIG.length == "few"     then MAP_NUM = 4 end
  if OB_CONFIG.length == "episode" then MAP_NUM = 9 end
  if OB_CONFIG.length == "full"    then MAP_NUM = 9 ; EP_NUM = 3 end

  for episode = 1,EP_NUM do
    for map = 1,MAP_NUM do

      local LEV =
      {
        name = string.format("E%dL%d", episode, map),

        episode  = episode,
        ep_along = map / MAP_NUM,
        ep_info  = { },

        keys = { foo=50 },
        switches = { foo=50 },
        bars = { },
      }

      table.insert(GAME.all_levels, LEV)
    end -- for map

  end -- for episode
end



------------------------------------------------------------


OB_THEMES["nukem_city"] =
{
  label = "City",
  for_games = { nukem=1 },

  prefix = "CITY",
  name_theme = "URBAN",

  mixed_prob = 50,
}


OB_GAMES["nukem"] =
{
  label = "Duke Nukem",

  setup_func = Nukem_setup,
  levels_start_func = Nukem_get_levels,

  param =
  {
    format = "nukem",

    rails = true,
    switches = true,
    liquids = true,
    teleporters = true,
    noblaze_door = true,

    no_keys = true,

    seed_size = 256,

    max_name_length = 28,

    skip_monsters = { 20,30 },

    mon_time_max = 12,

    mon_damage_max  = 200,
    mon_damage_high = 100,
    mon_damage_low  =   1,

    ammo_factor   = 0.8,
    health_factor = 0.7,
  },

  tables =
  {
    "player_model", NUKEM_PLAYER_MODEL,
    
    "things",   NUKEM_THINGS,
    "monsters", NUKEM_MONSTERS,
    "weapons",  NUKEM_WEAPONS,
    "pickups",  NUKEM_PICKUPS,

    "materials", NUKEM_MATERIALS,
    "themes",    NUKEM_SUB_THEMES,
  },
}

