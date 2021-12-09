--------------------------------------------------------------------
--  AMULETS LEVELS
--------------------------------------------------------------------
--
--  Copyright (C) 2006-2016 Andrew Apted
--  Copyright (C)      2011 Armaetus
--  Copyright (C) 2019 MsrSgtShooterPerson
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
--------------------------------------------------------------------

AMULETS.SECRET_EXITS =
{

}

AMULETS.EPISODES =
{
  -- these correspond to the seven quests

  episode1 =
  {
    theme = "amulets_city",
    sky_light = 0.75,
    maps = { "l30", "l301", "l531", "l31", "l22" },
  },

  episode2 =
  {
    theme = "amulets_city",
    sky_light = 0.75,
    maps = { "l25", "l20", "l60" },
  },

  episode3 =
  {
    theme = "amulets_city",
    sky_light = 0.75,
    maps = { "l64", "l65", "l34", "l151", "l152", "l153" },
  },

  episode4 =
  {
    theme = "amulets_city",
    sky_light = 0.75,
    maps = { "l231", "l75", "l10", "l12" },
  },

  episode5 =
  {
    theme = "amulets_city",
    sky_light = 0.75,
    maps = { "l51", "l52", "l41", "l44" },
  },

  episode6 =
  {
    theme = "amulets_city",
    sky_light = 0.75,
    maps = { "l74", "l73", "l72" },
  },

  episode7 =
  {
    theme = "amulets_city",
    sky_light = 0.75,
    maps = { "l32", "l71", "l70", "l61", "l40" },
  }
}

AMULETS.PREBUILT_LEVELS =
{

}


function AMULETS.setup()
 -- nothing needed
end


function AMULETS.get_levels()
  local EP_NUM  = sel(OB_CONFIG.length == "full", 7 , 1)
  local MAP_NUM = sel(OB_CONFIG.length == "single", 1 , 5)

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
        name = string.format("E%dM%d", episode, map),
        wad_name = ep_info.maps[map],

        episode  = episode,
        ep_along = ep_along,
        ep_info  = ep_info
      }

      table.insert(GAME.levels, LEV)
    end -- for map

  end -- for episode
end
