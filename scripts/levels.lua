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
  name : string  -- engine name for this level, e.g. MAP01

  epi_along : float  -- how far along the episode, 0.0 -> 1.0
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


function Game_merge_tab(name, t)
  if not t then
    error("Missing table for Game_merge_tab: " .. tostring(name))
  end

  if not GAME[name] then
    GAME[name] = {}
  end

  deep_merge(GAME[name], t)
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


function Level_Make(L, index, NUM)
  LEVEL = L

  assert(LEVEL)
  assert(LEVEL.name)

  gui.rand_seed(OB_CONFIG.seed * 100 + index)

  gui.printf("\n\n~~~~~~| %s |~~~~~~\n", LEVEL.name)

  gui.at_level(LEVEL.name, index, NUM)

  Plan_rooms_sp()
    if gui.abort() then return "abort" end
    gui.progress(20)

  Connect_Rooms()
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

  dummy_builder()
    if gui.abort() then return "abort" end
    gui.progress(100)

  -- intra-level cleanup
  if index < NUM then
    LEVEL = nil
    PLAN  = nil
    SEEDS = nil

    collectgarbage("collect")
  end

  return "ok"
end


function Level_MakeAll()

  assert(HOOKS.get_levels)

  local levels = HOOKS.get_levels()
  assert(#levels > 0)

  for index,L in ipairs(levels) do
    if Level_Make(L, index, #levels) == "abort" then
      return "abort"
    end
  end

  return "ok"
end

