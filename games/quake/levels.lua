------------------------------------------------------------------------
--  QUAKE LEVELS
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2012 Andrew Apted
--  Copyright (C)      2011 Chris Pisarczyk
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

QUAKE.EPISODES =
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
}


QUAKE.SECRET_EXITS =
{
  -- TODO
}


----------------------------------------------------

function QUAKE.get_levels()
  local  EP_NUM = sel(OB_CONFIG.length == "full",   4, 1)
  local MAP_NUM = sel(OB_CONFIG.length == "single", 1, 7)

  if OB_CONFIG.length == "few"     then MAP_NUM = 3 end
  if OB_CONFIG.length == "episode" then MAP_NUM = 6 end

  local SKIP_MAPS =
  {
    -- not present in original
    e2m7 = 1, e3m7 = 1,

    -- boss maps
    e1m7 = 2, e2m6 = 2,
    e3m6 = 2, e4m7 = 2,
  }

  for ep_index = 1,EP_NUM do
    -- create episode info...
    local EPI =
    {
      levels = {}
    }

    table.insert(GAME.episodes, EPI)

    local ep_info = QUAKE.EPISODES["episode" .. ep_index]
    assert(ep_info)

    for map = 1,MAP_NUM do
      local name = string.format("e%dm%d", ep_index, map)

      if SKIP_MAPS[name] then
        continue
      end

      local ep_along = map / MAP_NUM

      -- create level info....
      local LEV =
      {
        episode = EPI

        name = name
        next_map = string.format("e%dm%d", ep_index, map+1)

          ep_along = ep_along
        game_along = (ep_index - 1 + ep_along) / EP_NUM
      }

      table.insert( EPI.levels, LEV)
      table.insert(GAME.levels, LEV)

    end -- for map

  end -- for episode
end

