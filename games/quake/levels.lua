------------------------------------------------------------------------
--  QUAKE LEVELS
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2012 Andrew Apted
--  Copyright (C)      2011 Reisal
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

QUAKE.EPISODES =
{
  episode1 =
  {
    ep_index = 1,
    theme = "q1_tech",
    sky_light = 0.75,
  },

  episode2 =
  {
    ep_index = 2,
    theme = "q1_tech",
    sky_light = 0.75,
  },

  episode3 =
  {
    ep_index = 3,
    theme = "q1_castle",
    sky_light = 0.75,
  },

  episode4 =
  {
    ep_index = 4,
    theme = "q1_castle",
    sky_light = 0.75,
  },
}


QUAKE.SECRET_EXITS =
{
  -- TODO
}

QUAKE.PREBUILT_LEVELS =
{
  -- TODO
}

----------------------------------------------------

function QUAKE.get_levels()

  local SKIP_MAPS =
  {
    -- not present in original
    e2m7 = 1, e3m7 = 1,

    -- boss maps
    e1m7 = 2, e2m6 = 2,
    e3m6 = 2, e4m7 = 2,
  }
  local EP_NUM  = sel(OB_CONFIG.length == "game",   4, 1)
  local MAP_NUM = sel(OB_CONFIG.length == "single", 1, 7)

  if OB_CONFIG.length == "few" then MAP_NUM = 3 end
  if OB_CONFIG.length == "episode" then MAP_NUM = 6 end

  -- create episode info...

  for ep_index = 1,4 do
    local ep_info = QUAKE.EPISODES["episode" .. ep_index]
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

        name = string.format("e%dm%d", ep_index, map),

        ep_along = ep_along,
        game_along = (ep_index - 1 + ep_along) / EP_NUM
      }

      if SKIP_MAPS[name] then
        goto continue
      end

      table.insert( EPI.levels, LEV)
      table.insert(GAME.levels, LEV)

      LEV.secret_exit = GAME.SECRET_EXITS[LEV.name]

      -- prebuilt levels
      LEV.prebuilt = GAME.PREBUILT_LEVELS[LEV.name]

      if LEV.prebuilt then
        LEV.name_theme = LEV.prebuilt.name_theme or "BOSS"
      end

          -- procedural gotcha management code

    -- Prebuilts are to exist over procedural gotchas
    -- this means procedural gotchas will not override
    -- Icon of Sin for example if prebuilts are still on
    if not LEV.prebuilt then

      --handling for the Final Only option
      if PARAM.gotcha_frequency == "final" then
        if OB_CONFIG.length == "single" then
          if map == 1 then LEV.is_procedural_gotcha = true end
        elseif OB_CONFIG.length == "few" then
          if map == 4 then LEV.is_procedural_gotcha = true end
        elseif OB_CONFIG.length == "episode" then
          if map == 11 then LEV.is_procedural_gotcha = true end
        elseif OB_CONFIG.length == "game" then
          if map == 30 then LEV.is_procedural_gotcha = true end
        end
      end

      --every 10 maps
      if PARAM.gotcha_frequency == "epi" then
        if map == 11 or map == 20 or map == 30 then
          LEV.is_procedural_gotcha = true
        end
      end
      if PARAM.gotcha_frequency == "2epi" then
        if map == 5 or map == 11 or map == 16 or map == 20 or map == 25 or map == 30 then
          LEV.is_procedural_gotcha = true
        end
      end
      if PARAM.gotcha_frequency == "3epi" then
        if map == 3 or map == 7 or map == 11 or map == 14 or map == 17 or map == 20 or map == 23 or map == 27 or map == 30 then
          LEV.is_procedural_gotcha = true
        end
      end
      if PARAM.gotcha_frequency == "4epi" then
        if map == 3 or map == 6 or map == 9 or map == 11 or map == 14 or map == 16 or map == 18 or map == 20 or map == 23 or map == 26 or map == 28 or map == 30 then
          LEV.is_procedural_gotcha = true
        end
      end

      --5% of maps after map 4
      if PARAM.gotcha_frequency == "5p" then
        if map > 4 and map ~= 15 and map ~= 31 then
          if rand.odds(5) then LEV.is_procedural_gotcha = true end
        end
      end

      -- 10% of maps after map 4
      if PARAM.gotcha_frequency == "10p" then
        if map > 4 and map ~= 15 and map ~= 31 then
          if rand.odds(10) then LEV.is_procedural_gotcha = true end
        end
      end

      -- for masochists... or debug testing
      if PARAM.gotcha_frequency == "all" then
        LEV.is_procedural_gotcha = true
      end
    end

    -- handling for street mode
    -- actual handling for urban percentages are done
    if PARAM.float_streets_mode then
      if not LEV.is_procedural_gotcha or not LEV.prebuilt then
        if rand.odds(PARAM.float_streets_mode) then
          LEV.has_streets = true
        end
      end
    end

    if not LEV.prebuilt then
      if PARAM.float_linear_mode then
        if rand.odds(PARAM.float_linear_mode) then
          LEV.is_linear = true
        end
      end

      -- nature mode
      if PARAM.float_nature_mode then
        if rand.odds(PARAM.float_nature_mode) then
          if LEV.has_streets then
            if rand.odds(50) then
              LEV.has_streets = false
              LEV.is_nature = true
            end
          else
            LEV.is_nature = true
          end
        end
      end

    end
    ::continue::
    end -- for map

    -- set "dist_to_end" value
    if MAP_NUM >= 3 then
      EPI.levels[#EPI.levels].dist_to_end = 1
      EPI.levels[#EPI.levels-1].dist_to_end = 2
    end

  end -- for episode

end