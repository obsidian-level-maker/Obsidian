----------------------------------------------------------------
--  Oblige
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006,2007 Andrew Apted
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
----------------------------------------------------------------

require 'defs'
require 'util'
require 'a_star'

require 'prefab'
require 'theme'

require 'planner'
require 'plan_dm'

require 'monster'
require 'builder'
require 'writer'


function create_GAME()

  local factory = GAME_FACTORIES[SETTINGS.game]

  if not factory then
    error("UNKNOWN GAME '" .. SETTINGS.game .. "'")
  end

  GAME = factory()

  name_up_theme()
  expand_prefabs(PREFABS)
  compute_pow_factors()
end


function create_LEVEL(level, index, total)

  con.at_level(level, index, total)

  con.rand_seed(SETTINGS.seed * 100 + index)

  con.printf("\n======| %s |======\n\n", level.name)

  if SETTINGS.mode == "dm" then
    plan_dm_arena(level)
  else
    plan_sp_level(level, SETTINGS.mode == "coop")
  end

  if con.abort() then return "abort" end

  if SETTINGS.mode == "dm" then
    show_dm_links()
  else
    show_path()
  end
  con.printf("\n")

  build_level()

  if con.abort() then return "abort" end

  if GAME.wolf_format then
    write_wolf_level()
  else
    write_level(level.name)
  end

  if con.abort() then return "abort" end

  make_mini_map()

  PLAN = nil

  collectgarbage("collect");
end


function build_cool_shit()
 
  assert(SETTINGS)
  assert(SETTINGS.game)

  -- the missing console functions
  con.printf = function (fmt, ...)
    if fmt then con.raw_log_print(string.format(fmt, ...)) end
  end

  con.debugf = function (fmt, ...)
    if fmt then con.raw_debug_print(string.format(fmt, ...)) end
  end

  con.printf("\n\n~~~~~~~ Making Levels ~~~~~~~\n\n")

  con.printf("SEED = %d\n\n", SETTINGS.seed)
  con.printf("Settings =\n%s\n", table_to_str(SETTINGS))

  con.rand_seed(SETTINGS.seed * 100)

  create_GAME()

  assert(GAME)
  assert(GAME.level_func)

  local aborted = false
  local episode_num

  if SETTINGS.length == "single" then
    episode_num = 1
  elseif SETTINGS.length == "episode" then
    episode_num = GAME.min_episodes or 1
  else -- SETTINGS.length == "full"
    episode_num = GAME.episodes
  end

  -- build episode/level lists
  local all_levels = {}

  for epi = 1,episode_num do
    local levels = GAME.level_func(epi)
    for zzz, L in ipairs(levels) do
      table.insert(all_levels, L)
    end
  end

  local total = #all_levels

  if SETTINGS.length == "single" then
    total = 1
  end

  for index = 1,total do

    local result = create_LEVEL(all_levels[index], index, total)

    if result == "abort" then
      aborted = true
      break;
    end
  end

  if aborted then
    con.printf("\n~~~~~~~ Build Aborted! ~~~~~~~\n\n")
    return "abort"
  end

  con.printf("\n~~~~~~ Finished Making Levels ~~~~~~\n\n")

  return "ok"
end

