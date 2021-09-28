--------------------------------------------------------------------
--  WOLF3D LEVELS
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

WOLF.SECRET_EXITS =
{

}


WOLF.EPISODES =
{
  episode1 =
  {
    boss = "Hans",
    theme = "wolf_bunker",
    sky_light = 0.75,
    secret_exits = { "E1L1" },
  },

  episode2 =
  {
    boss = "Schabbs",
    theme = "wolf_bunker",
    sky_light = 0.75,
    secret_exits = { "E2L1" },
  },

  episode3 =
  {
    boss = "Hitler",
    theme = "wolf_bunker",
    sky_light = 0.75,
    secret_exits = { "E3L7" },
  },

  episode4 =
  {
    boss = "Giftmacher",
    theme = "wolf_bunker",
    sky_light = 0.75,
    secret_exits = { "E4L3" },
  },

  episode5 =
  {
    boss = "Gretel",
    theme = "wolf_bunker",
    sky_light = 0.75,
    secret_exits = { "E5L5" },
  },

  episode6 =
  {
    boss = "Fatface",
    theme = "wolf_bunker",
    sky_light = 0.75,
    secret_exits = { "E6L3" },
  },
}


WOLF.PREBUILT_LEVELS =
{

}


--------------------------------------------------------------------

function wolfy_decide_quests(level_list, is_spear)

  local function add_quest(L, kind, item, secret_prob)
    secret_prob = 0 --FIXME !!!!

    local len_probs = non_nil(WOLF.QUEST_LEN_PROBS[kind])
    local Quest =
    {
      kind = kind,
      item = item,
      want_len = 1 + rand.index_by_probs(len_probs),
    }
    if item == "secret" or (secret_prob and rand.odds(secret_prob)) then
      Quest.is_secret = true
      -- need at least one room in-between (for push-wall)
      if Quest.want_len < 3 then Quest.want_len = 3 end
    end
    table.insert(L.quests, Quest)
    return Quest
  end

  for zzz,Level in ipairs(level_list) do

    -- weapons and keys

    if rand.odds(90 - 40 * ((Level.ep_along-1) % 3)) then
      add_quest(Level, "weapon", "machine_gun", 35)
    end

    local keys = rand.index_by_probs(WOLF.KEY_NUM_PROBS[SETTINGS.size]) - 1

    if keys >= 1 then
      add_quest(Level, "key", "k_silver")
    end

    -- treasure

    local ITEM_PROBS = { small=33, regular=45, large=66 }

    for i = 1,sel(is_spear,4,6) do
      if rand.odds(ITEM_PROBS[SETTINGS.size]) then
        add_quest(Level, "item", "treasure", 50)
      end
    end

    if is_spear and rand.odds(60) then
      add_quest(Level, "item", "clip_25", 50)
    end

    -- bosses and exits

    if Level.boss_kind then
      local Q = add_quest(Level, "boss", Level.boss_kind)
      Q.give_key = "k_gold"

    elseif keys == 2 then
      add_quest(Level, "key", "k_gold")
    end

    if Level.secret_exit then
--FIXME  add_quest(Level, "exit", "secret")
    end

    add_quest(Level, "exit", "normal")
  end
end

function WOLF.get_levels()
  local MAP_LEN_TAB = { few=4, episode=10, game=60 }
  local MAP_NUM = MAP_LEN_TAB[OB_CONFIG.length] or 1

  local EP_NUM = 1
  if MAP_NUM > 10 then EP_NUM = 2 end
  if MAP_NUM > 20 then EP_NUM = 3 end
  if MAP_NUM > 30 then EP_NUM = 4 end
  if MAP_NUM > 40 then EP_NUM = 5 end
  if MAP_NUM > 50 then EP_NUM = 6 end

  -- create episode info...

  for ep_index = 1,6 do
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

    if OB_CONFIG.length == "episode" then
      GAME.levels[#GAME.levels - 1].dist_to_end = 2
      GAME.levels[#GAME.levels - 2].dist_to_end = 3
    end
  end
end

--[[ Previous stuff below here --

  for episode = 1,EP_NUM do
    local ep_info = WOLF.EPISODES["episode" .. episode]
    assert(ep_info)

--    local boss_kind = WOLF.EPISODE_BOSSES[episode]
--    if OB_CONFIG.length ~= "full" then
--      boss_kind = WOLF.EPISODE_BOSSES[rand.irange(1,6)]
--    end

    local secret_kind = "pacman"

    for map = 1,MAP_NUM do
      local Level =
      {
        name = string.format("E%dL%d", episode, map),

        episode  = episode,
        ep_along = ((map - 1) % 10) / 9,

        styles = {},
      }

--      if WOLF.SECRET_EXITS[Level.name] then
--        Level.secret_exit = true
--      end

      table.insert(GAME.levels, Level)
    end -- for map

  end -- for episode

--  local function dump_levels()
--    for idx,L in ipairs(list) do
--      gui.printf("Wolf3d episode [%d] map [%d] : %s\n", episode, idx, L.name)
--      show_quests(L.quests)
--    end
--  end

-- FIXME  wolfy_decide_quests(list)

--  dump_levels()]]--
