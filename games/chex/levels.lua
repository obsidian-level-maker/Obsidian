--------------------------------------------------------------------
--  CHEX3 LEVELS
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

CHEX3.SECRET_EXITS =
{

}


CHEX3.EPISODES =
{
  episode1 =
  {
    ep_index = 1,

    theme = "spaceport",
    sky_patch = "CJSKY3A",
    boss = "Maximus",
    sky_light = 0.75,
    dark_prob = 10
  },

-- E2M5 and E3M5 will exit when all bosses (Maximus, Flembomination
-- and Snotfolus) are dead, so perhaps prevent an exit door or
-- switch from appearing if any of those appear in these levels?

  episode2 =
  {
    ep_index = 2,

    theme = "spaceport",
    sky_patch = "CJSKY3A",
    boss = "Flembomination",
    sky_light = 0.75,
    dark_prob = 10
  },

  episode3 =
  {
    ep_index = 3,

    theme = "spaceport",
    sky_patch = "CJSKY3A",
    boss = "Snotfolus",
    sky_light = 0.75,
    dark_prob = 10
  }
}


CHEX3.PREBUILT_LEVELS =
{

}


--------------------------------------------------------------------

function CHEX3.get_levels()
  local EP_NUM  = sel(OB_CONFIG.length == "game",   3, 1)
  local MAP_NUM = sel(OB_CONFIG.length == "single", 1, 9)

  if OB_CONFIG.length == "few" then MAP_NUM = 4 end

  -- create episode info...

  for ep_index = 1,3 do
    local ep_info = CHEX3.EPISODES["episode" .. ep_index]
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
      if OB_CONFIG.procedural_gotchas == "final" then
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
      if OB_CONFIG.procedural_gotchas == "epi" then
        if map == 11 or map == 20 or map == 30 then
          LEV.is_procedural_gotcha = true
        end
      end
      if OB_CONFIG.procedural_gotchas == "2epi" then
        if map == 5 or map == 11 or map == 16 or map == 20 or map == 25 or map == 30 then
          LEV.is_procedural_gotcha = true
        end
      end
      if OB_CONFIG.procedural_gotchas == "3epi" then
        if map == 3 or map == 7 or map == 11 or map == 14 or map == 17 or map == 20 or map == 23 or map == 27 or map == 30 then
          LEV.is_procedural_gotcha = true
        end
      end
      if OB_CONFIG.procedural_gotchas == "4epi" then
        if map == 3 or map == 6 or map == 9 or map == 11 or map == 14 or map == 16 or map == 18 or map == 20 or map == 23 or map == 26 or map == 28 or map == 30 then
          LEV.is_procedural_gotcha = true
        end
      end

      --5% of maps after map 4
      if OB_CONFIG.procedural_gotchas == "5p" then
        if map > 4 and map ~= 15 and map ~= 31 then
          if rand.odds(5) then LEV.is_procedural_gotcha = true end
        end
      end

      -- 10% of maps after map 4
      if OB_CONFIG.procedural_gotchas == "10p" then
        if map > 4 and map ~= 15 and map ~= 31 then
          if rand.odds(10) then LEV.is_procedural_gotcha = true end
        end
      end

      -- for masochists... or debug testing
      if OB_CONFIG.procedural_gotchas == "all" then
        LEV.is_procedural_gotcha = true
      end
    end

    -- handling for street mode
    -- actual handling for urban percentages are done
    if not LEV.is_procedural_gotcha or not LEV.prebuilt then
      if rand.odds(PARAM.float_streets_mode) then
        LEV.has_streets = true
      end
    end

    if not LEV.prebuilt then
      if rand.odds(PARAM.float_linear_mode) then
        LEV.is_linear = true
      end

      -- nature mode
      if PARAM.float_nature_mode and not LEV.has_streets then
        if rand.odds(PARAM.float_nature_mode) then
          LEV.is_nature = true
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

