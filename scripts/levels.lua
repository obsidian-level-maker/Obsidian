----------------------------------------------------------------
--  LEVEL MANAGEMENT
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006-2008 Andrew Apted
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

--[[ *** CLASS INFORMATION ***


--------------------------------------------------------------]]

require 'defs'
require 'util'

require 'seeds'
require 'plan_sp'
require 'connect'
require 'quests'
require 'rooms'
require 'builder'

-- require 'monsters'



--- !!! OLD CRUD:
function create_GAME()

  local factory = GAME_FACTORIES[OB_CONFIG.game]

  if not factory then
    error("UNKNOWN GAME '" .. OB_CONFIG.game .. "'")
  end

  GAME = factory()

  name_up_theme()
  expand_prefabs(PREFABS)
  compute_pow_factors()
end

--- !!! OLD CRUD:
function create_LEVEL(level, index, total)

  gui.at_level(level, index, total)

  gui.rand_seed(OB_CONFIG.seed * 100 + index)

  gui.printf("\n======| %s |======\n\n", level.name)

  if OB_CONFIG.mode == "dm" then
    plan_dm_arena(level)
  else
    plan_sp_level(level, OB_CONFIG.mode == "coop")
  end

  if gui.abort() then return "abort" end

  if OB_CONFIG.mode == "dm" then
    show_dm_links()
  else
    show_path()
  end
  gui.printf("\n")

  build_level()

  if gui.abort() then return "abort" end

  if GAME.wolf_format then
    write_wolf_level()
  else
    write_level(level.name)
  end

  if gui.abort() then return "abort" end

  make_mini_map()

  PLAN = nil

  collectgarbage("collect")
end



function Level_Setup()

end


function Level_CleanUp()

end


function Level_Make(level, NUM)

  gui.rand_seed(OB_CONFIG.seed * 100 + level)

  local level_name = string.format("MAP%02d", level)

  gui.printf("\n\n~~~~~~| %s |~~~~~~\n", level_name)

  gui.at_level(level_name, level, NUM)

  local epi_along = ((level - 1) % 10) / 9

  Plan_rooms_sp(epi_along)
    if gui.abort() then return "abort" end
    gui.progress(20)

  Connect_Rooms(epi_along)
    if gui.abort() then return "abort" end
    gui.progress(30)

  Quest_assign()
    if gui.abort() then return "abort" end
    gui.progress(40)

  Rooms_fit_out()
    if gui.abort() then return "abort" end
    gui.progress(60)

  Seed_grow()

  dummy_builder(level_name)
    if gui.abort() then return "abort" end
    gui.progress(100)

end


function Level_MakeAll()

-- [[ TEST STUFF
local NUM = 1
  if OB_CONFIG.length == "episode" then
    NUM = 10
  elseif OB_CONFIG.length == "full" then
    NUM = 30
  end

for level = 1,NUM do

  if Level_Make(level, NUM) == "abort" then
    return "abort"
  end
end

do return "ok" end
--]]


--- !!! OLD STUFF:
  create_GAME()

  assert(GAME)
  assert(GAME.level_func)

  local aborted = false
  local episode_num

  if OB_CONFIG.length == "single" then
    episode_num = 1
  elseif OB_CONFIG.length == "episode" then
    episode_num = GAME.min_episodes or 1
  else -- OB_CONFIG.length == "full"
    episode_num = GAME.episodes
  end

  -- build episode/level lists
  local all_levels = {}

  for epi = 1,episode_num do
    local levels = GAME.level_func(epi)
    for _,L in ipairs(levels) do
      table.insert(all_levels, L)
    end
  end

  local total = #all_levels

  if OB_CONFIG.length == "single" then
    total = 1
  end

  for index = 1,total do

    local result = create_LEVEL(all_levels[index], index, total)

    if result == "abort" then
      aborted = true
      break;
    end
  end

end

