------------------------------------------------------------------------
--  HERETIC LEVELS
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2017 Andrew Apted
--  Copyright (C)      2008 Sam Trenholme
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

HERETIC.SECRET_EXITS =
{
  E1M6 = true,
  E2M4 = true,
  E3M4 = true,
  E4M4 = true,
  E5M3 = true
}


HERETIC.EPISODES =
{
  episode1 =
  {
    ep_index = 1,

    theme = "city",
    boss = "Ironlich",
    sky_patch = "SKY1",
    dark_prob = 10,
    sky_light = 0.65,
  },

  episode2 =
  {
    ep_index = 2,

    theme = "maw",
    boss = "Maulotaur",
    sky_patch = "SKY2",
    dark_prob = 10,
    sky_light = 0.75,
  },

  episode3 =
  {
    ep_index = 3,

    theme = "dome",
    boss = "D_Sparil",
    sky_patch = "SKY3",
    dark_prob = 10,
    sky_light = 0.75,
  },

  episode4 =
  {
    ep_index = 4,

    theme = "ossuary",
    boss = "Ironlich",
    sky_patch = "SKY4",
    dark_prob = 10,
    sky_light = 0.50,
  },

  episode5 =
  {
    ep_index = 5,

    theme = "demense",
    boss = "Maulotaur",
    sky_patch = "SKY5",
    dark_prob = 10,
    sky_light = 0.65,
  },
}

HERETIC.PREBUILT_LEVELS =
{
  E1M8 =
  {
    { prob=50, file="games/heretic/data/boss_maw1.wad", map="E1M8" },
  },

  E2M8 =
  {
    { prob=50, file="games/heretic/data/boss_portal1.wad", map="E2M8" },
  },
}


------------------------------------------------------------

function HERETIC.get_levels()
  local EP_NUM  = sel(OB_CONFIG.length == "game",   5, 1)
  local MAP_NUM = sel(OB_CONFIG.length == "single", 1, 9)

  if OB_CONFIG.length == "few" then MAP_NUM = 4 end

  -- create episode info...

  for ep_index = 1,5 do
    local ep_info = HERETIC.EPISODES["episode" .. ep_index]
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

        name = string.format("E%dM%d", ep_index, map),

          ep_along = ep_along,
        game_along = (ep_index - 1 + ep_along) / EP_NUM
      }

      table.insert( EPI.levels, LEV)
      table.insert(GAME.levels, LEV)

      LEV.secret_exit = GAME.SECRET_EXITS[LEV.name]

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
          if map == 1 then LEV.is_procedural_gotcha = true end
        elseif OB_CONFIG.length == "few" then
          if map == 4 then LEV.is_procedural_gotcha = true end
        elseif OB_CONFIG.length == "episode" then
          if map == 8 then LEV.is_procedural_gotcha = true end
        elseif OB_CONFIG.length == "game" then
          if map == 44 then LEV.is_procedural_gotcha = true end
        end
      end

      if PARAM.gotcha_frequency == "epi" then
        if map == ep_index * 9 - 1 then
          LEV.is_procedural_gotcha = true
        end
      end
      if PARAM.gotcha_frequency == "2epi" then
        if map == ep_index * 9 - 1 or map == ep_index * 9 - 5 then
          LEV.is_procedural_gotcha = true
        end
      end
      if PARAM.gotcha_frequency == "3epi" then
        if map == ep_index * 9 - 1 or map == ep_index * 9 - 4 or map == ep_index * 9 - 7 then
          LEV.is_procedural_gotcha = true
        end
      end
      if PARAM.gotcha_frequency == "4epi" then
        if map == ep_index * 9 - 1 or map == ep_ined * 9 - 3 or map == ep_index * 9 - 5 or map == ep_index * 9 - 7 then
          LEV.is_procedural_gotcha = true
        end
      end

      --5% of maps after map 4,
      if PARAM.gotcha_frequency == "5p" then
        if map > 4 and map % 9 ~= 0 then
          if rand.odds(5) then LEV.is_procedural_gotcha = true end
        end
      end

      -- 10% of maps after map 4,
      if PARAM.gotcha_frequency == "10p" then
        if map > 4 and map % 9 ~= 0 then
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

    end -- for map

    -- set "dist_to_end" value
    if MAP_NUM >= 9 then
      EPI.levels[7].dist_to_end = 1
      EPI.levels[6].dist_to_end = 2
    end

  end -- for episode

end

