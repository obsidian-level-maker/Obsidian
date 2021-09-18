--------------------------------------------------------------------
--  NUKEM LEVELS
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

NUKEM.SECRET_EXITS =
{

}


NUKEM.EPISODES =
{
  episode1 =
  {

  },

  episode2 =
  {

  },

  episode3 =
  {

  }
}


NUKEM.PREBUILT_LEVELS =
{

}


--------------------------------------------------------------------

function NUKEM.get_levels()
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
        ep_info  = { }
      }

      table.insert(GAME.levels, LEV)

    end -- for map
  end -- for episode
end
