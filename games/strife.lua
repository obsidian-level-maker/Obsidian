---------------------------------------------------------------
--  GAME DEFINITION : Strife
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2009-2010 Andrew Apted
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

STRIFE = { }

STRIFE.ENTITIES =
{
  --- special stuff ---
  player1 = { id=1, r=16, h=56 }
  player2 = { id=2, r=16, h=56 }
  player3 = { id=3, r=16, h=56 }
  player4 = { id=4, r=16, h=56 }

  dm_player     = { id=11 }
  teleport_spot = { id=14 }

  --- monsters ---
  acolyte = { id=1234, r=16, h=56 }

  --- bosses ---

  --- pickups ---
  k_yellow   = { id=80 }

  --- scenery ---
  wall_torch  = { id=50, r=10, h=64, light=255 }

}


STRIFE.PARAMETERS =
{
  sub_format = "strife"

  rails = true
  switches = true
  light_brushes = true

  max_name_length = 28

  skip_monsters = { 20,30 }

  time_factor   = 1.0
  damage_factor = 1.0
  ammo_factor   = 0.8
  health_factor = 0.7
}


----------------------------------------------------------------

STRIFE.MATERIALS =
{
  -- special materials --
  _ERROR = { t="BIGSTN02", f="P_SPLATR" }
  _SKY   = { t="BIGSTN01", f="F_SKY001" }

  -- textures --

  BRKGRY01 = { t="BRKGRY01", f="F_BRKTOP" }
  BRKGRY17 = { t="BRKGRY17", f="F_BRKTOP" }
  WALCAV01 = { t="WALCAV01", f="F_CAVE01" }

  -- flats --

  F_BRKTOP = { t="BRKGRY01", f="F_BRKTOP" }
  F_CAVE01 = { t="WALCAV01", f="F_CAVE01" }

}


----------------------------------------------------------------

STRIFE.COMBOS =
{
  BRICK1 =
  {
    wall = "BRKGRY01"
  }

  CAVE1 =
  {
    outdoor = true,

    wall  = "WALCAV01",
    floor = "WALCAV01",
    ceil  = "WALCAV01",
  }
}


STRIFE.LEVEL_THEMES =
{
  TECH =
  {
    building_walls =
    {
      BRICK1=50,
    }

    building_floors =
    {
      F_BRKTOP=50,
    }

    building_ceilings =
    {
      F_BRKTOP=50,
    }

    courtyard_floors =
    {
      CAVE1=20,
    }
  }, -- TECH
}


------------------------------------------------------------

STRIFE.MONSTERS =
{
  -- FIXME : STRIFE.MONSTERS
}


STRIFE.WEAPONS =
{
  dagger =
  {
    attack = "melee"
    rate = 1.5
    damage = 10
  }

  -- FIXME : STRIFE.WEAPONS
}


STRIFE.PICKUPS =
{
  -- FIXME : STRIFE.PICKUPS
}


STRIFE.PLAYER_MODEL =
{
  strifeguy =
  {
    stats   = { health=0 }
    weapons = { dagger=1 }
  }
}


------------------------------------------------------------


function STRIFE.setup()
  -- do stuff here
end


function STRIFE.get_levels()
  local EP_NUM  = 1
  local MAP_NUM = 1

  if OB_CONFIG.length == "few"     then MAP_NUM = 4 end
  if OB_CONFIG.length == "episode" then MAP_NUM = 9 end
  if OB_CONFIG.length == "full"    then MAP_NUM = 9 ; EP_NUM = 3 end

  for episode = 1,EP_NUM do
    for map = 1,MAP_NUM do

      local LEV =
      {
        name = string.format("MAP%d%d", episode-1, map)
        episode  = episode
        ep_along = map / MAP_NUM
        ep_info  = { }
      }

      table.insert(GAME.levels, LEV)
    end -- for map

  end -- for episode
end



------------------------------------------------------------

UNFINISHED["strife"] =
{
  label = "Strife"

  format = "doom"

  tables =
  {
    STRIFE
  }

  hooks =
  {
    setup      = STRIFE.setup
    get_levels = STRIFE.get_levels
  }
}


-- TODO:  OB_THEMES["strife_xxx"] = ...

