--------------------------------------------------------------------
--  CHEX1 LEVELS
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

CHEX1.SECRET_EXITS =
{

}


CHEX1.EPISODES =
{
  episode1 =
  {
    ep_index = 1,

    theme = "bazoik",
    sky_patch = "SKY1",
    boss = "Maximus",
    sky_light = 0.75,
    dark_prob = 10
  },
}


CHEX1.PREBUILT_LEVELS =
{

}


--------------------------------------------------------------------

function CHEX1.get_levels()
  local EP_NUM  = sel(OB_CONFIG.length == "game",   1, 1)
  local MAP_NUM = sel(OB_CONFIG.length == "single", 1, 5)

  if OB_CONFIG.length == "few" then MAP_NUM = 4 end

  -- create episode info...

  for ep_index = 1,1 do
    local ep_info = CHEX1.EPISODES["episode" .. ep_index]
    assert(ep_info)

    local EPI = table.copy(ep_info)

    EPI.levels = { }

    table.insert(GAME.episodes, EPI)
  end

  -- create level info...

  local current_map = 1

  for ep_index = 1,EP_NUM do
    local EPI = GAME.episodes[ep_index]

    for map = 1,MAP_NUM do
      -- create level info...
      local ep_along = map / MAP_NUM

      local LEV =
      {
        episode  = EPI,

        name = string.format("E%dM%d", ep_index, map),

          ep_along = ep_along,
        game_along = (ep_index - 1 + ep_along) / EP_NUM
      }

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
          if current_map == 1 then LEV.is_procedural_gotcha = true end
        elseif OB_CONFIG.length == "few" then
          if current_map == 4 then LEV.is_procedural_gotcha = true end
        elseif OB_CONFIG.length == "episode" then
          if current_map == 5 then LEV.is_procedural_gotcha = true end
        elseif OB_CONFIG.length == "game" then
          if current_map == 5 then LEV.is_procedural_gotcha = true end
        end
      end

      if PARAM.gotcha_frequency == "epi" then
        if current_map == 3 then
          LEV.is_procedural_gotcha = true
        end
      end
      if PARAM.gotcha_frequency == "2epi" then
        if current_map == 2 or current_map == 4 then
          LEV.is_procedural_gotcha = true
        end
      end
      if PARAM.gotcha_frequency == "3epi" then
        if current_map == 1 or current_map == 3 or current_map == 5 then
          LEV.is_procedural_gotcha = true
        end
      end
      if PARAM.gotcha_frequency == "4epi" then
        if current_map ~= 1 then
          LEV.is_procedural_gotcha = true
        end
      end

      --5% of maps after map 4
      if PARAM.gotcha_frequency == "5p" then
        if current_map > 4 then
          if rand.odds(5) then LEV.is_procedural_gotcha = true end
        end
      end

      -- 10% of maps after map 4
      if PARAM.gotcha_frequency == "10p" then
        if current_map > 4 then
          if rand.odds(10) then LEV.is_procedural_gotcha = true end
        end
      end

      -- for masochists... or debug testing
      if PARAM.gotcha_frequency == "all" then
        LEV.is_procedural_gotcha = true
      end
    end

    local special_mode = {}

    if PARAM.float_streets_mode and rand.odds(PARAM.float_streets_mode) then
      table.add_unique(special_mode, "streets")
    end
 
    if PARAM.float_linear_mode and rand.odds(PARAM.float_linear_mode) then
      table.add_unique(special_mode, "linear")
    end

    if PARAM.float_nature_mode and rand.odds(PARAM.float_nature_mode) then
      table.add_unique(special_mode, "nature")
    end

    if not table.empty(special_mode) and not LEV.prebuilt then
      local selected_mode = rand.pick(special_mode)
      if selected_mode == "streets" then
        LEV.has_streets = true
        LEV.is_linear = false
        LEV.is_nature = false
      elseif selected_mode == "linear" then
        LEV.has_streets = false
        LEV.is_linear = true
        LEV.is_nature = false
      else
        LEV.has_streets = false
        LEV.is_linear = false
        LEV.is_nature = true
      end
    else
      LEV.has_streets = false
      LEV.is_linear = false
      LEV.is_nature = false
    end

    current_map = current_map + 1

    end -- for map

    -- set "dist_to_end" value
    if MAP_NUM >= 5 then
      EPI.levels[3].dist_to_end = 1
      EPI.levels[2].dist_to_end = 2
    end

  end -- for episode

end

