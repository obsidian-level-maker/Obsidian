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
--    sky_light = 0.65,
  },

  episode2 =
  {
    ep_index = 2,

    theme = "maw",
    boss = "Maulotaur",
    sky_patch = "SKY2",
    dark_prob = 10,
--    sky_light = 0.75,
  },

  episode3 =
  {
    ep_index = 3,

    theme = "dome",
    boss = "D_sparil",
    sky_patch = "SKY3",
    dark_prob = 10,
--    sky_light = 0.75,
  },

  episode4 =
  {
    ep_index = 4,

    theme = "ossuary",
    boss = "Ironlich",
    sky_patch = "SKY3",
    dark_prob = 10,
--    sky_light = 0.50,
  },

  episode5 =
  {
    ep_index = 5,

    theme = "demense",
    boss = "Maulotaur",
    sky_patch = "SKY3",
    dark_prob = 10,
--    sky_light = 0.65,
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

      --5% of maps after map 4,
      if OB_CONFIG.procedural_gotchas == "5p" then
        if map > 4 and map ~= 15 and map ~= 31 then
          if rand.odds(5) then LEV.is_procedural_gotcha = true end
        end
      end

      -- 10% of maps after map 4,
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
    -- MSSP-TODO: Clean this up! Down with cascading elseif statements!
    if not LEV.is_procedural_gotcha or not LEV.prebuilt then
      if OB_CONFIG.streets_mode == "75" and rand.odds(75) then
        LEV.has_streets = true
      elseif OB_CONFIG.streets_mode == "50" and rand.odds(50) then
        LEV.has_streets = true
      elseif OB_CONFIG.streets_mode == "25" and rand.odds(25) then
        LEV.has_streets = true
      elseif OB_CONFIG.streets_mode == "13" and rand.odds(13) then
        LEV.has_streets = true
      elseif OB_CONFIG.streets_mode == "all" then
        LEV.has_streets = true
      end
    end

    if not LEV.prebuilt then
      if OB_CONFIG.linear_mode == "all" then
        LEV.is_linear = true
      elseif OB_CONFIG.linear_mode ~= "none" then
        if rand.odds(int(OB_CONFIG.linear_mode)) then
          LEV.is_linear = true
        end
      end

      -- nature mode
      if OB_CONFIG.nature_mode and not LEV.has_streets then
        if OB_CONFIG.nature_mode == "all" then
          LEV.is_nature = true
        elseif OB_CONFIG.nature_mode ~= "none" then
          if rand.odds(int(OB_CONFIG.nature_mode)) then
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

