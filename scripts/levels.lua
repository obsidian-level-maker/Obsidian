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
require 'planner'
require 'connect'
require 'naming'
require 'quests'
require 'builder'
require 'rooms'

--!! require 'monsters'


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

  -- setup RNG for whole-game random choices
  gui.rand_seed(OB_CONFIG.seed)


  local game = OB_GAMES[OB_CONFIG.game]
  if not game then
    error("UNKNOWN GAME: " .. tostring(OB_CONFIG.game))
  end

  if game.caps   then shallow_merge(CAPS,   game.caps) end
  if game.params then shallow_merge(PARAMS, game.params) end
  if game.hooks  then shallow_merge(HOOKS,  game.hooks) end

  assert(game.setup_func)

  game.setup_func(game)

  GAME.format = game.format


  local engine = OB_ENGINES[OB_CONFIG.engine]
  if not engine then
    error("UNKNOWN ENGINE: " .. tostring(OB_CONFIG.engine))
  end

  if engine.caps   then shallow_merge(CAPS,   engine.caps) end
  if engine.params then shallow_merge(PARAMS, engine.params) end
  if engine.hooks  then shallow_merge(HOOKS,  engine.hooks) end

  if engine.setup_func then
     engine.setup_func(engine)
  end


  -- FIXME: ordering of modules

  for _,mod in pairs(OB_MODULES) do
    if mod.enabled then
      if mod.caps   then shallow_merge(CAPS,   mod.caps) end
      if mod.params then shallow_merge(PARAMS, mod.params) end
      if mod.hooks  then shallow_merge(HOOKS,  mod.hooks) end

      if mod.setup_func then
         mod.setup_func(mod)
      end
    end
  end -- for mod


  if CAPS.pack_sidedefs then
    gui.property("pack_sidedefs", "1")
  end
end


function Level_Make(L, index, NUM)
  LEVEL = L

  assert(LEVEL)
  assert(LEVEL.name)

  gui.rand_seed(OB_CONFIG.seed * 100 + index)

  gui.printf("\n\n~~~~~~| %s |~~~~~~\n", LEVEL.name)

  gui.at_level(LEVEL.name, index, NUM)

  -- FIXME: invoke "level_start" signal

  Plan_rooms_sp()
    if gui.abort() then return "abort" end
    gui.progress(10)

  Connect_Rooms()
    if gui.abort() then return "abort" end
    gui.progress(15)

  Quest_assign()
    if gui.abort() then return "abort" end
    gui.progress(25)

  gui.begin_level()
  gui.property("level_name", LEVEL.name);

  if LEVEL.description then
    if HOOKS.set_level_desc then
       HOOKS.set_level_desc(LEVEL.description)
    else
      gui.property("description", LEVEL.description)
    end
  end

  if PARAMS.error_tex then
    gui.property("error_tex",  PARAMS.error_tex)
    gui.property("error_flat", PARAMS.error_flat or PARAMS.error_tex)
  end   


  Rooms_lay_out_II()
    if gui.abort() then return "abort" end
    gui.progress(60)

  Builder()
    if gui.abort() then return "abort" end
    gui.progress(100)

  gui.end_level()

  -- FIXME: invoke "level_finish" signal
  if HOOKS.make_level_gfx and LEVEL.description then
     HOOKS.make_level_gfx(LEVEL.description)
  end

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

  -- FIXME: invoke "all_start" signal

  assert(HOOKS.get_levels)

  GAME.all_levels = HOOKS.get_levels()
  assert(#GAME.all_levels > 0)

  if HOOKS.describe_levels then
     HOOKS.describe_levels()
  end

  for index,L in ipairs(GAME.all_levels) do
    if Level_Make(L, index, #GAME.all_levels) == "abort" then
      return "abort"
    end
  end

  -- FIXME: invoke "all_finish" signal
  if HOOKS.remap_music then
     HOOKS.remap_music()
  end

  if HOOKS.generate_skies then
     HOOKS.generate_skies()
  end

  return "ok"
end

