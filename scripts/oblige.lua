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
--- require 'theme'

require 'planner'
require 'plan_dm'

require 'monster'
require 'builder'
require 'writer'

require 'engines'

require 'test_csg'


OB_THEMES["mixed"] =
{
  label = "Mix It Up",
  priority = 95,
}


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


function create_LEVEL(level, index, total)

  con.at_level(level, index, total)

  con.rand_seed(OB_CONFIG.seed * 100 + index)

  con.printf("\n======| %s |======\n\n", level.name)

  if OB_CONFIG.mode == "dm" then
    plan_dm_arena(level)
  else
    plan_sp_level(level, OB_CONFIG.mode == "coop")
  end

  if con.abort() then return "abort" end

  if OB_CONFIG.mode == "dm" then
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

  collectgarbage("collect")
end


----------------------------------------------------------------
--  FUNCTIONS CALLED FROM GUI CODE
----------------------------------------------------------------

function ob_traceback(msg)

  -- guard against very early errors
  if not con or not con.printf then
    return msg
  end
 
--con.printf("\nERROR: %s\n\n", msg)
  con.printf("\nStack Trace:\n")

  local stack_limit = 40

  local function format_source(info)
    if not info.short_src or info.currentline <= 0 then
      return ""
    end

    local base_fn = string.match(info.short_src, "[^/]*$")
 
    return string.format("@ %s:%d", base_fn, info.currentline)
  end

  for i = 1,stack_limit do
    local info = debug.getinfo(i+1)
    if not info then break end

    if i == stack_limit then
      con.printf("(remaining stack trace omitted)\n")
      break;
    end

    if info.what == "Lua" then

      local func_name = "???"

      if info.namewhat and info.namewhat ~= "" then
        func_name = info.name or "???"
      else
        -- perform our own search of the global namespace,
        -- since the standard LUA code (5.1.2) will not check it
        -- for the topmost function (the one called by C code)
        for k,v in pairs(_G) do
          if v == info.func then
            func_name = k
            break;
          end
        end
      end

      con.printf("  %d: %s() %s\n", i, func_name, format_source(info))

    elseif info.what == "main" then

      con.printf("  %d: main body %s\n", i, format_source(info))

    elseif info.what == "tail" then

      con.printf("  %d: tail call\n", i)

    elseif info.what == "C" then

      if info.namewhat and info.namewhat ~= "" then
        con.printf("  %d: c-function %s()\n", i, info.name or "???")
      end
    end
  end

  return msg
end


function ob_match_conf(tab)

  assert(OB_CONFIG.game)
  assert(OB_CONFIG.mode)
  assert(OB_CONFIG.engine)

  if tab.for_games then
    if not tab.for_games[OB_CONFIG.game] then
      return false
    end
  end

  if tab.for_modes then
    if not tab.for_modes[OB_CONFIG.mode] then
      return false
    end
  end

  if tab.for_engines then
    if not tab.for_engines[OB_CONFIG.engine] then
      return false
    end
  end

  return true --OK--
end


function ob_button_sorter(A, B)
  if A.priority or B.priority then
    return (A.priority or 0) > (B.priority or 0)
  end

  return A.label < B.label
end


function ob_setup_game_button()

  if not OB_GAMES or table_empty(OB_GAMES) then
    error("No game definitions were loaded!")
  end

  local game_list = {}

  for name,info in pairs(OB_GAMES) do
    assert(info.name)
    assert(info.label)

    table.insert(game_list, info)
  end

  table.sort(game_list, ob_button_sorter)

  for xxx,info in ipairs(game_list) do
    con.game_button(info.name, info.label)
  end
end


function ob_setup_engine_button()

  if not OB_ENGINES or table_empty(OB_ENGINES) then
    error("No engine definitions were loaded!")
  end

  local engine_list = {}

  for name,info in pairs(OB_ENGINES) do
    assert(info.name)
    assert(info.label)

    table.insert(engine_list, info)
  end

  table.sort(engine_list, ob_button_sorter)

  local count = 0

  for xxx,info in ipairs(engine_list) do
    if ob_match_conf(info) then
      con.engine_button(info.name, info.label)
      count = count + 1
    end
  end

  if count == 0 then
    error("No engines matching current game!")
  end
end


function ob_setup_theme_button()

  if not OB_THEMES or table_empty(OB_THEMES) then
    error("No themes definitions were loaded!")
  end

  local theme_list = {}

  for name,info in pairs(OB_THEMES) do
    assert(info.name)
    assert(info.label)

    table.insert(theme_list, info)
  end

  table.sort(theme_list, ob_button_sorter)

  local count = 0

  for xxx,info in ipairs(theme_list) do
    if ob_match_conf(info) then
      con.theme_button(info.name, info.label)
      count = count + 1
    end
  end

  if count == 0 then
    error("No themes matching current game!")
  end
end


function ob_init()

  -- the missing console functions
  con.printf = function (fmt, ...)
    if fmt then con.raw_log_print(string.format(fmt, ...)) end
  end

  con.debugf = function (fmt, ...)
    if fmt then con.raw_debug_print(string.format(fmt, ...)) end
  end

  name_it_up(OB_GAMES)
  name_it_up(OB_THEMES)
  name_it_up(OB_ENGINES)
  name_it_up(OB_MODS)
  name_it_up(OB_MOPTS)

  local function button_sorter(A, B)
    if A.priority or B.priority then
      return (A.priority or 0) > (B.priority or 0)
    end

    return A.label < B.label
  end

  local function create_buttons(what, DEFS)
    assert(DEFS)
  
    local list = {}

    for name,def in pairs(DEFS) do
      assert(def.name and def.label)
      table.insert(list, def)
    end

    table.sort(list, button_sorter)

    for xxx,def in ipairs(list) do
      con.add_button(what, def.name, def.label)
    end
  end

  create_buttons("game",   OB_GAMES)
  create_buttons("theme",  OB_THEMES)
  create_buttons("engine", OB_ENGINES)
  create_buttons("mod",    OB_MODS)
  create_buttons("option", OB_MOPTS)
end


function ob_build_cool_shit()
 
  assert(OB_CONFIG)
  assert(OB_CONFIG.game)


  con.printf("\n\n~~~~~~~ Making Levels ~~~~~~~\n\n")

  con.printf("SEED = %d\n\n", OB_CONFIG.seed)
  con.printf("Settings =\n%s\n", table_to_str(OB_CONFIG))

  con.rand_seed(OB_CONFIG.seed * 100)


--[[  CSG TEST CODE
  wad.begin_level("MAP01");
  
  test_csg();

  wad.end_level();

  do return "ok" end
--]]


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
    for zzz, L in ipairs(levels) do
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

  if aborted then
    con.printf("\n~~~~~~~ Build Aborted! ~~~~~~~\n\n")
    return "abort"
  end

  con.printf("\n~~~~~~ Finished Making Levels ~~~~~~\n\n")

  return "ok"
end

