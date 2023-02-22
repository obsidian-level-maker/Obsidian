--------------------------------------------------------------------
--  DOOM LEVELS
--------------------------------------------------------------------
--
--  Copyright (C) 2006-2016 Andrew Apted
--  Copyright (C)      2011 Armaetus
--  Copyright (C) 2019-2022 MsrSgtShooterPerson
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
--------------------------------------------------------------------

DOOM.SECRET_EXITS =
{
  E1M3 = true,
  E2M5 = true,
  E3M6 = true,
  E4M2 = true
}


DOOM.EPISODES =
{
  episode1 =
  {
    ep_index = 1,

    theme = "tech",
    sky_patch = "SKY1",
    dark_prob = 10,

    name_patch = "M_EPI1",
    description = "Knee-Deep in the Dead",
    bex_end_name = "E1TEXT",
  },

  episode2 =
  {
    ep_index = 2,

    theme = "deimos",
    sky_patch = "SKY2",
    dark_prob = 40,

    name_patch = "M_EPI2",
    description = "The Shores of Hell",
    bex_end_name = "E2TEXT",
  },

  episode3 =
  {
    ep_index = 3,

    theme = "hell",
    sky_patch = "SKY3",
    dark_prob = 10,

    name_patch = "M_EPI3",
    description = "Inferno",
    bex_end_name = "E3TEXT",
  },

  episode4 =
  {
    ep_index = 4,

    theme = "flesh",
    sky_patch = "SKY4",
    dark_prob = 10,

    name_patch = "M_EPI4",
    description  = "Thy Flesh Consumed",
    bex_end_name = "E4TEXT",
  },
}

DOOM.PREBUILT_LEVELS =
{
  E1M8 =
  {
    { prob=50,  file="games/doom/data/boss1/anomaly1.wad", map="E1M8" },
    { prob=50,  file="games/doom/data/boss1/anomaly2.wad", map="E1M8" },
    { prob=100, file="games/doom/data/boss1/anomaly3.wad", map="E1M8" },
    { prob=50,  file="games/doom/data/boss1/ult_anomaly.wad",  map="E1M8" },
    { prob=100, file="games/doom/data/boss1/ult_anomaly2.wad", map="E1M8" },
  },

  E2M8 =
  {
    { prob=40,  file="games/doom/data/boss1/tower1.wad", map="E2M8" },
    { prob=60,  file="games/doom/data/boss1/tower2.wad", map="E2M8" },
    { prob=100, file="games/doom/data/boss1/ult_tower.wad", map="E2M8" },
  },

  E3M8 =
  {
    { prob=50,  file="games/doom/data/boss1/dis1.wad", map="E3M8" },
    { prob=100, file="games/doom/data/boss1/ult_dis.wad", map="E3M8" },
  },

  E4M6 =
  {
    { prob=50, file="games/doom/data/boss1/tower1.wad", map="E2M8" },
  },

  E4M8 =
  {
    { prob=50, file="games/doom/data/boss1/dis1.wad", map="E3M8" },
  },
}


--------------------------------------------------------------------

function DOOM.get_levels()
  local EP_MAX  = sel(OB_CONFIG.game   == "ultdoom", 4, 3)
  local EP_NUM  = sel(OB_CONFIG.length == "game", EP_MAX, 1)

  local MAP_LEN_TAB = { single=1, few=4 }

  local MAP_NUM = MAP_LEN_TAB[OB_CONFIG.length] or 9

  -- this accounts for last two levels are BOSS and SECRET level
  local LEV_MAX = MAP_NUM
  if LEV_MAX == 9 then LEV_MAX = 7 end

  -- create episode info...

  for ep_index = 1,4 do
    local ep_info = GAME.EPISODES["episode" .. ep_index]
    assert(ep_info)

    local EPI = table.copy(ep_info)

    EPI.levels = { }

    table.insert(GAME.episodes, EPI)
  end

  -- create level info...

  current_map = 1

  for ep_index = 1,EP_NUM do
    local EPI = GAME.episodes[ep_index]

    for map = 1,MAP_NUM do
      local ep_along = map / MAP_NUM

      local LEV =
      {
        episode = EPI,

        name  = string.format("E%dM%d",   ep_index,   map),
        patch = string.format("WILV%d%d", ep_index-1, map-1),

        ep_along = ep_along,
        game_along = (ep_index - 1 + ep_along) / EP_NUM
      }

      table.insert( EPI.levels, LEV)
      table.insert(GAME.levels, LEV)

      LEV.secret_exit = GAME.SECRET_EXITS[LEV.name]

      if map == 9 then
        LEV.is_secret = true
      end

      -- prebuilt levels
      if PARAM.bool_prebuilt_levels == 1 then
        LEV.prebuilt = GAME.PREBUILT_LEVELS[LEV.name]
      end

      if LEV.prebuilt then
        LEV.name_class = LEV.prebuilt.name_class or "BOSS"
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
            if current_map == 8 then LEV.is_procedural_gotcha = true end
          elseif OB_CONFIG.length == "game" then
            if current_map == 35 then LEV.is_procedural_gotcha = true end
          end
        end
  
        if PARAM.gotcha_frequency == "epi" then
          if current_map == ep_index * 9 - 1 then
            LEV.is_procedural_gotcha = true
          end
        end
        if PARAM.gotcha_frequency == "2epi" then
          if current_map == ep_index * 9 - 1 or current_map == ep_index * 9 - 5 then
            LEV.is_procedural_gotcha = true
          end
        end
        if PARAM.gotcha_frequency == "3epi" then
          if current_map == ep_index * 9 - 1 or current_map == ep_index * 9 - 4 or current_map == ep_index * 9 - 7 then
            LEV.is_procedural_gotcha = true
          end
        end
        if PARAM.gotcha_frequency == "4epi" then
          if current_map == ep_index * 9 - 1 or current_map == ep_index * 9 - 3 or current_map == ep_index * 9 - 5 or current_map == ep_index * 9 - 7 then
            LEV.is_procedural_gotcha = true
          end
        end
  
        --5% of maps after map 4,
        if PARAM.gotcha_frequency == "5p" then
          if current_map > 4 and current_map % 9 ~= 0 then
            if rand.odds(5) then LEV.is_procedural_gotcha = true end
          end
        end
  
        -- 10% of maps after map 4,
        if PARAM.gotcha_frequency == "10p" then
          if current_map > 4 and current_map % 9 ~= 0 then
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

      if MAP_NUM == 1 or map == 3 then
        LEV.demo_lump = string.format("DEMO%d", ep_index)
      end

      current_map = current_map + 1

    end -- for map

    -- set "dist_to_end" value
    if MAP_NUM >= 9 then
      EPI.levels[7].dist_to_end = 1
      EPI.levels[6].dist_to_end = 2
      EPI.levels[5].dist_to_end = 3

    elseif MAP_NUM == 4 then
      EPI.levels[4].dist_to_end = 1
      EPI.levels[3].dist_to_end = 3
    end

  end -- for episode

end