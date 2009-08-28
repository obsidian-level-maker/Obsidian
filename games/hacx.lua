----------------------------------------------------------------
--  GAME DEFINITION : HacX
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2009 Andrew Apted
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

HACX_THINGS =
{
  --- special stuff ---
  player1 = { id=1, kind="other", r=16,h=56 },
  player2 = { id=2, kind="other", r=16,h=56 },
  player3 = { id=3, kind="other", r=16,h=56 },
  player4 = { id=4, kind="other", r=16,h=56 },

  dm_player     = { id=11, kind="other", r=16,h=56 },
  teleport_spot = { id=14, kind="other", r=16,h=56 },

  --- monsters ---
  acolyte = { id=1234, kind="monster", r=16,h=56 },

  -- bosses

  --- pickups ---
  k_yellow   = { id=80, kind="pickup", r=20,h=16, pass=true },

  --- scenery ---
  wall_torch  = { id=50, kind="scenery", r=10,h=64, light=255 },

}


----------------------------------------------------------------

HACX_MATERIALS =
{
  -- special materials --
  _ERROR = { t="BIGSTN02", f="P_SPLATR" },
  _SKY   = { t="BIGSTN01", f="F_SKY001"  },

  -- textures --

  BRKGRY01 = { t="BRKGRY01", f="F_BRKTOP" },
  BRKGRY17 = { t="BRKGRY17", f="F_BRKTOP" },
  WALCAV01 = { t="WALCAV01", f="F_CAVE01" },

  -- flats --

  F_BRKTOP = { t="BRKGRY01", f="F_BRKTOP" },
  F_CAVE01 = { t="WALCAV01", f="F_CAVE01" },

}


HACX_SANITY_MAP =
{
  -- FIXME
}


----------------------------------------------------------------

HACX_COMBOS =
{
  BRICK1 =
  {
    wall = "BRKGRY01"
  },

  CAVE1 =
  {
    outdoor = true,

    wall  = "WALCAV01",
    floor = "WALCAV01",
    ceil  = "WALCAV01",
  }
}


HACX_THEMES =
{
  TECH =
  {
    building =
    {
      BRICK1=50,
    },

    floors =
    {
      F_BRKTOP=50,
    },

    ceilings =
    {
      F_BRKTOP=50,
    },

    ground =
    {
      CAVE1=20,
    },
  }, -- TECH
}


------------------------------------------------------------

HACX_MONSTERS =
{
  -- FIXME : HACX_MONSTERS
}


HACX_WEAPONS =
{
  dagger =
  {
    rate=1.5, damage=10, attack="melee",
  },

  -- FIXME : HACX_WEAPONS
}


HACX_PICKUPS =
{
  -- FIXME : HACX_PICKUPS
}


HACX_PLAYER_MODEL =
{
  danny =
  {
    stats = { health=0, bolt=0, bullet=0, missile=0,
              grenade=0, cell=0 },

    weapons = { dagger=1 },
  }
}


------------------------------------------------------------


function HacX_setup()
  -- nothing needed
end


function HacX_get_levels()
  local EP_NUM  = 1
  local MAP_NUM = 1

  -- FIXME: copy n paste DOOM2 logic
  if OB_CONFIG.length == "few"     then MAP_NUM = 4 end
  if OB_CONFIG.length == "episode" then MAP_NUM = 9 end
  if OB_CONFIG.length == "full"    then MAP_NUM = 9 ; EP_NUM = 3 end

  for episode = 1,EP_NUM do
    for map = 1,MAP_NUM do

      local LEV =
      {
        name = string.format("MAP%d%d", episode-1, map),

        episode  = episode,
        ep_along = map / MAP_NUM,
        ep_info  = { },

        key_list = { "foo" },
        switch_list = { "foo" },
        bar_list = { "foo" },
      }

      table.insert(GAME.all_levels, LEV)
    end -- for map

  end -- for episode
end



------------------------------------------------------------


OB_GAMES["hacx"] =
{
  label = "HacX 1.1",

  setup_func = HacX_setup,
  levels_start_func = HacX_get_levels,

  param =
  {
    format = "doom",

    rails = true,
    switches = true,
    liquids = true,
    teleporters = true,
    noblaze_door = true,

    no_keys = true,

    seed_size = 256,

    max_name_length = 28,

    skip_monsters = { 20,30 },

    time_factor   = 1.0,
    damage_factor = 1.0,
    ammo_factor   = 0.8,
    health_factor = 0.7,
  },

  tables =
  {
    "player_model", HACX_PLAYER_MODEL,
    
    "things",   HACX_THINGS,
    "monsters", HACX_MONSTERS,
    "weapons",  HACX_WEAPONS,
    "pickups",  HACX_PICKUPS,

    "materials", HACX_MATERIALS,

    "combos",   HACX_COMBOS,
    "themes",   HACX_THEMES,
  },
}

