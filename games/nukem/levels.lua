--------------------------------------------------------------------
--  NUKEM LEVELS
--------------------------------------------------------------------
--
--  Copyright (C) 2006-2016 Andrew Apted
--  Copyright (C)      2011 Reisal
--  Copyright (C) 2019 MsrSgtShooterPerson
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
--------------------------------------------------------------------

NUKEM.SECRET_EXITS =
{

}


NUKEM.EPISODES =
{
  episode1 =
  {
    ep_index = 1,
    theme = "nukem_city",
    boss = "Boss1",
  },

  episode2 =
  {
    ep_index = 2,
    theme = "nukem_city",
    boss = "Boss2",
  },

  episode3 =
  {
    ep_index = 3,
    theme = "nukem_city",
    boss = "Boss3",
  }
}


NUKEM.PREBUILT_LEVELS =
{

}


--------------------------------------------------------------------

function NUKEM.get_levels()
  local EP_NUM  = sel(OB_CONFIG.length == "game",   3, 1)
  local MAP_NUM = sel(OB_CONFIG.length == "single", 1, 9)

  if OB_CONFIG.length == "few" then MAP_NUM = 4 end

  -- create episode info...

  for ep_index = 1,3 do
    local ep_info = NUKEM.EPISODES["episode" .. ep_index]
    assert(ep_info)

    local EPI = table.copy(ep_info)

    EPI.levels = { }

    table.insert(GAME.episodes, EPI)
  end

  -- create level info...

  for ep_index = 1,EP_NUM do
    local EPI = GAME.episodes[ep_index]

    for map = 1,MAP_NUM do
      -- create level info...
      local ep_along = map / MAP_NUM

      local LEV =
      {
        episode  = EPI,

        name = string.format("E%dL%d", ep_index, map),

          ep_along = ep_along,
        game_along = (ep_index - 1 + ep_along) / EP_NUM
      }

      table.insert( EPI.levels, LEV)
      table.insert(GAME.levels, LEV)

      LEV.secret_exit = GAME.SECRET_EXITS[LEV.name]
    end
  end
end
