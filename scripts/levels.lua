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

class LEVEL
{
}


--------------------------------------------------------------]]

require 'defs'
require 'util'

require 'seeds'
require 'plan_sp'
require 'connect'
require 'quests'
require 'rooms'
require 'layout'
require 'builder'

-- require 'monsters'



--- !!! OLD CRUD:
function create_GAME()

  local factory = GAME_FACTORIES[OB_CONFIG.game]

  if not factory then
    error("UNKNOWN GAME: " .. tostring(OB_CONFIG.game))
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



function Level_CleanUp()
  GAME   = {}
  CAPS   = {}
  PARAMS = {}
  HOOKS  = {}

  LEVEL = nil
  PLAN  = nil
  SEEDS = nil

  collectgarbage("collect")
end


function Level_Setup()

  Level_CleanUp()


  local game = OB_GAMES[OB_CONFIG.game]
  if not game then
    error("UNKNOWN GAME: " .. tostring(OB_CONFIG.game))
  end

  if game.caps   then merge_table(CAPS,   game.caps) end
  if game.params then merge_table(PARAMS, game.params) end
  if game.hooks  then merge_table(HOOKS,  game.hooks) end

  assert(game.setup_func)

  game.setup_func(game)


  local engine = OB_ENGINES[OB_CONFIG.engine]
  if not engine then
    error("UNKNOWN ENGINE: " .. tostring(OB_CONFIG.engine))
  end

  if engine.caps   then merge_table(CAPS,   engine.caps) end
  if engine.params then merge_table(PARAMS, engine.params) end
  if engine.hooks  then merge_table(HOOKS,  engine.hooks) end

  if engine.setup_func then
     engine.setup_func(engine)
  end


  -- FIXME: ordering of modules

  for _,mod in pairs(OB_MODULES) do
    if mod.enabled then
      if mod.caps   then merge_table(CAPS,   mod.caps) end
      if mod.params then merge_table(PARAMS, mod.params) end
      if mod.hooks  then merge_table(HOOKS,  mod.hooks) end

      if mod.setup_func then
         mod.setup_func(mod)
      end
    end
  end -- for mod
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

  Rooms_II()
    if gui.abort() then return "abort" end
    gui.progress(70)

  Seed_grow()

  dummy_builder(level_name)
    if gui.abort() then return "abort" end
    gui.progress(100)

  -- intra-level cleanup
  LEVEL = nil
  PLAN  = nil
  SEEDS = nil

  collectgarbage("collect")
end


function Level_MakeAll()

-- [[ TEST STUFF
Level_Setup()

local NUM = 1
  if OB_CONFIG.length == "episode" then
    NUM = 10
  elseif OB_CONFIG.length == "full" then
    NUM = 30
  end

for level = 1,NUM do

  if Level_Make(level, NUM) == "abort" then
    Level_CleanUp()
    return "abort"
  end
end

Level_CleanUp()

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

