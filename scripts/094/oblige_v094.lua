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

gui.import("094/defs.lua")
gui.import("util.lua")
gui.import("094/a_star.lua")

gui.import("094/theme")

gui.import("094/planner")
gui.import("094/plan_dm")

gui.import("094/monster")
gui.import("094/builder")
gui.import("094/writer")


function v094_create_LEVEL(level, index, total)

  gui.at_level(level.name, index, total)

  gui.printf("\n======| %s |======\n\n", level.name)

  if PARAM.bool_historical_oblige_v2_dm_mode == 1 then
    plan_dm_arena(level)
  else
    plan_sp_level(level, OB_CONFIG.mode == "coop")
  end

  if gui.abort() then return "abort" end

  if PARAM.bool_historical_oblige_v2_dm_mode == 1 then
    show_dm_links()
  else
    show_path()
  end
  gui.printf("\n")

  build_level()

  if gui.abort() then return "abort" end

  if GAME.FACTORY.wolf_format then
    write_wolf_level()
  else
    write_level(level.name)
  end

  if gui.abort() then return "abort" end

  make_mini_map()

  PLAN = nil

  collectgarbage("collect");

  return "ok"
end


function v094_build_wolf3d_shit()

  assert(GAME.FACTORY)
  assert(GAME.FACTORY.level_func)

  local aborted = false
  local episode_num

  if OB_CONFIG.length == "single" then
    episode_num = 1
  elseif OB_CONFIG.length == "episode" then
    episode_num = GAME.FACTORY.min_episodes or 1
  else
    episode_num = GAME.FACTORY.episodes
  end

  -- build episode/level lists
  local all_levels = {}

  for epi = 1,episode_num do
    local levels = GAME.FACTORY.level_func(epi)
    for zzz, L in ipairs(levels) do
      table.insert(all_levels, L)
    end
  end

  local total = #all_levels

  if OB_CONFIG.length == "single" then
    total = 1
  elseif OB_CONFIG.length == "few" then
    total = 4
  end

  for index = 1,total do

    local result = v094_create_LEVEL(all_levels[index], index, total)

    if result == "abort" then
      aborted = true
      break;
    end
  end

  if aborted then
    gui.printf("\n~~~~~~~ Build Aborted! ~~~~~~~\n\n")
    return "abort"
  end

  gui.printf("\n~~~~~~ Finished Making Levels ~~~~~~\n\n")

  return "ok"
end

