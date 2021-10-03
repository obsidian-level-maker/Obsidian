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
  local EP_NUM  = sel(OB_CONFIG.length == "game",   6, 1)
  local MAP_NUM = sel(OB_CONFIG.length == "single", 1, 10)

  if OB_CONFIG.length == "few" then MAP_NUM = 4 end

  -- create episode info...

  for ep_index = 1,6 do
    local ep_info = WOLF.EPISODES["episode" .. ep_index]
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
