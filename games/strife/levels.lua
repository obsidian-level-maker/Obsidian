--------------------------------------------------------------------
--  STRIFE LEVELS
--------------------------------------------------------------------
--
--  Copyright (C) 2006-2016 Andrew Apted
--  Copyright (C)      2011 Armaetus
--  Copyright (C) 2019 MsrSgtShooterPerson
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
--------------------------------------------------------------------

STRIFE.SECRET_EXITS =
{

}


STRIFE.EPISODES =
{
  episode1 =
  {
    ep_index = 1,

    theme = "town",
    sky_patch = "P_BLUE1",
    dark_prob = 10,
  },

  episode2 =
  {
    ep_index = 2,

    theme = "town",
    sky_patch = "P_BLUE1",
    dark_prob = 40,
  },

  episode3 =
  {
    ep_index = 3,

    theme = "town",
    sky_patch = "P_BLUE1",
    dark_prob = 10,
  },
}


STRIFE.PREBUILT_LEVELS =
{

}


--------------------------------------------------------------------


function STRIFE.get_levels()
  local MAP_LEN_TAB = { few=4, episode=11, game=32 }

  local MAP_NUM = MAP_LEN_TAB[OB_CONFIG.length] or 1

  local EP_NUM = 1
  if MAP_NUM > 11 then EP_NUM = 2 end
  if MAP_NUM > 30 then EP_NUM = 3 end

  -- create episode info...

  for ep_index = 1,3 do
    local ep_info = GAME.EPISODES["episode" .. ep_index]
    assert(ep_info)

    local EPI = table.copy(ep_info)

    EPI.levels = { }

    table.insert(GAME.episodes, EPI)
  end

  -- create level info...

  for map = 1,MAP_NUM do
    -- determine episode from map number
    local ep_index
    local ep_along

    local game_along = map / MAP_NUM

    if map > 30 then
      ep_index = 3 ; ep_along = 0.5 ; game_along = 0.5
    elseif map > 20 then
      ep_index = 3 ; ep_along = (map - 20) / 10
    elseif map > 11 then
      ep_index = 2 ; ep_along = (map - 11) / 9
    else
      ep_index = 1 ; ep_along = map / 11
    end

    if OB_CONFIG.length == "single" then
      game_along = 0.57
      ep_along   = 0.75

    elseif OB_CONFIG.length == "few" then
      ep_along = game_along
    end

    assert(ep_along <= 1.0)
    assert(game_along <= 1.0)

    local EPI = GAME.episodes[ep_index]
    assert(EPI)

    local LEV =
    {
      episode = EPI,

      name  = string.format("MAP%02d", map),

      ep_along = ep_along,
      game_along = game_along
    }

    table.insert( EPI.levels, LEV)
    table.insert(GAME.levels, LEV)

    -- the 'dist_to_end' value is used for Boss monster decisions
    if map >= 26 and map <= 29 then
      LEV.dist_to_end = 30 - map
    elseif map == 11 or map == 20 then
      LEV.dist_to_end = 1
    elseif map == 16 or map == 23 then
      LEV.dist_to_end = 2
    end

    -- prebuilt levels
    local pb_name = LEV.name

    if OB_CONFIG.prebuilt_levels == "yes" then
      LEV.prebuilt = GAME.PREBUILT_LEVELS[pb_name]
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

    -- handling for linear mode chance choices
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

    if MAP_NUM == 1 or (map % 10) == 3 then
      LEV.demo_lump = string.format("DEMO%d", ep_index)
    end
  end

  -- handle "dist_to_end" for FEW and EPISODE lengths
  if OB_CONFIG.length ~= "single" and OB_CONFIG.length ~= "game" then
    GAME.levels[#GAME.levels].dist_to_end = 1

    if OB_CONFIG.length == "episode" then
      GAME.levels[#GAME.levels - 1].dist_to_end = 2
      GAME.levels[#GAME.levels - 2].dist_to_end = 3
    end
  end
end
