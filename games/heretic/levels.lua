------------------------------------------------------------------------
--  HERETIC LEVELS
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2012 Andrew Apted
--  Copyright (C)      2008 Sam Trenholme
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

HERETIC.SECRET_EXITS =
{
  E1M6 = true
  E2M4 = true
  E3M4 = true
  E4M4 = true
  E5M3 = true
}


HERETIC.EPISODES =
{
  episode1 =
  {
    theme = "CITY"
    boss = "Ironlich"
    sky_light = 0.65
  }

  episode2 =
  {
    theme = "CITY"
    boss = "Maulotaur"
    sky_light = 0.75
  }

  episode3 =
  {
    theme = "CITY"
    boss = "D_sparil"
    sky_light = 0.75
  }

  episode4 =
  {
    theme = "CITY"
    boss = "Ironlich"
    sky_light = 0.50
  }

  episode5 =
  {
    theme = "CITY"
    boss = "Maulotaur"
    sky_light = 0.65
  }
}


------------------------------------------------------------

function HERETIC.get_levels()
  local EP_NUM  = (OB_CONFIG.length == "game"   ? 5 ; 1)
  local MAP_NUM = (OB_CONFIG.length == "single" ? 1 ; 9)

  if OB_CONFIG.length == "few" then MAP_NUM = 4 end

  for ep_index = 1,EP_NUM do
    -- create episode info...
    local EPI =
    {
      levels = {}
    }

    table.insert(GAME.episodes, EPI)

    local ep_info = HERETIC.EPISODES["episode" .. ep_index]
    assert(ep_info)

    for map = 1,MAP_NUM do
      -- create level info...
      local LEV =
      {
        episode  = EPI

        name = string.format("E%dM%d", ep_index, map)

         ep_along = map / MAP_NUM
        mon_along = (map + ep_index - 1) / MAP_NUM
      }

      table.insert( EPI.levels, LEV)
      table.insert(GAME.levels, LEV)

      LEV.secret_exit = GAME.SECRET_EXITS[LEV.name]

      -- prebuilt levels
      LEV.prebuilt = GAME.PREBUILT_LEVELS[LEV.name]

      if LEV.prebuilt then
        LEV.name_theme = LEV.prebuilt.name_theme or "BOSS"
      end

    end -- for map

  end -- for episode
end

