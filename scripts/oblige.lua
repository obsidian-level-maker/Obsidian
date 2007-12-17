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


function ob_match_conf(T)

  assert(OB_CONFIG.game)
  assert(OB_CONFIG.mode)
  assert(OB_CONFIG.engine)

  if T.for_games and not T.for_games[OB_CONFIG.game] then
    return false
  end

  if T.for_modes and not T.for_modes[OB_CONFIG.mode] then
    return false
  end

  if T.for_engines and not T.for_engines[OB_CONFIG.engine] then
    return false
  end

  if T.for_module then
    local def = OB_MODULES[T.for_module]
    if not (def and def.shown and def.enabled) then
      return false
    end
  end

  return true --OK--
end


function ob_update_engines()
  for name,def in pairs(OB_ENGINES) do
    con.show_button("engine", name, ob_match_conf(def))
  end
end


function ob_update_themes()
  for name,def in pairs(OB_THEMES) do
    con.show_button("theme", name, ob_match_conf(def))
  end
end


function ob_update_modules()
  -- modules may depend on other modules, hence we may need
  -- to repeat this multiple times until all the dependencies
  -- have flowed through.
  
  for loop = 1,10 do
    local changed = false

    for name,def in pairs(OB_MODULES) do
      local old_shown = def.shown
      def.shown = ob_match_conf(def)

      con.show_button("module", name, def.shown)

      if old_shown ~= def.shown then
        changes = true
      end
    end

    if not changed then return end
  end
end


function ob_update_options()
  for name,def in pairs(OB_OPTIONS) do
    def.shown = ob_match_conf(def)
    con.show_button("option", name, def.shown)
  end
end


function ob_update_all()
  ob_update_engines()
  ob_update_modules()
  ob_update_options()
  ob_update_themes()
end


function ob_default_config()
  -- Note: game, engine & theme are set up elsewhere

  --| Game Settings |--
  OB_CONFIG.seed   = 0
  OB_CONFIG.mode   = "sp"
  OB_CONFIG.length = "episode"

  --| Level Adjustments |--
  OB_CONFIG.size    = "regular"
  OB_CONFIG.detail  = "normal"
  OB_CONFIG.heights = "normal"
  OB_CONFIG.yyy     = "normal"
 
  --| Playing Style |--
  OB_CONFIG.mons    = "normal"
  OB_CONFIG.puzzles = "normal"
  OB_CONFIG.traps   = "normal"
  OB_CONFIG.health  = "normal"
  OB_CONFIG.ammo    = "normal"

  -- modules and options default to disabled
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
  name_it_up(OB_MODULES)
  name_it_up(OB_OPTIONS)

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

    return list[1] and list[1].name
  end

  ob_default_config()

  OB_CONFIG.game   = create_buttons("game",   OB_GAMES)
  OB_CONFIG.engine = create_buttons("engine", OB_ENGINES)
  OB_CONFIG.theme  = create_buttons("theme",  OB_THEMES)

  create_buttons("module", OB_MODULES)
  create_buttons("option", OB_OPTIONS)

end


function ob_parse_config(name, value)
  assert(name and value)

  if name == "seed" then
    OB_CONFIG[name] = tonumber(value) or 0
    return
  end

  if OB_CONFIG[name] then
    if OB_CONFIG[name] == value then
      return
    end

    -- validate some important variables
    if name == "game" then
      if not OB_GAMES[value] then
        con.printf("Ignoring unknown game: %s\n", value)
        return;
      end
    elseif name == "engine" then
      if not OB_ENGINES[value] then
        con.printf("Ignoring unknown engine: %s\n", value)
        return;
      end
    elseif name == "theme" then
      if not OB_THEMES[value] then
        con.printf("Ignoring unknown theme: %s\n", value)
        return;
      end
    end

    OB_CONFIG[name] = value

    if (name == "game") or (name == "mode") or (name == "engine") then
      ob_update_all()
    end

    return
  end

  -- convert 'value' from string to a boolean
  value = not (value == "false" or value == "0")

  if OB_MODULES[name] then
    if OB_MODULES[name].enabled == value then
      return
    end

    OB_MODULES[name].enabled = value

    ob_update_all()
    return
  end
    
  if OB_OPTIONS[name] then
    OB_OPTIONS[name].enabled = value
    -- nothing in the GUI depends on options
    return
  end

  con.printf("Unknown config variable: %s\n", name)
end


function ob_write_config()

  local function do_line(fmt, ...)
    con.config_line(string.format(fmt, ...))
  end

  do_line("-- Game Settings --\n");

  do_line("seed = %d\n",   OB_CONFIG.seed or 0)
  do_line("game = %s\n",   OB_CONFIG.game)
  do_line("mode = %s\n",   OB_CONFIG.mode)
  do_line("engine = %s\n", OB_CONFIG.engine)
  do_line("length = %s\n", OB_CONFIG.length)
  do_line("\n")

  do_line("-- Level Architecture --\n");
  do_line("theme = %s\n",   OB_CONFIG.theme)
  do_line("size = %s\n",    OB_CONFIG.size)
  do_line("detail = %s\n",  OB_CONFIG.detail)
  do_line("heights = %s\n", OB_CONFIG.heights)
  do_line("yyy = %s\n",     OB_CONFIG.yyy or "yyy")
  do_line("\n")

  do_line("-- Playing Style --\n");
  do_line("mons = %s\n",    OB_CONFIG.mons)
  do_line("puzzles = %s\n", OB_CONFIG.puzzles)
  do_line("traps = %s\n",   OB_CONFIG.traps)
  do_line("health = %s\n",  OB_CONFIG.health)
  do_line("ammo = %s\n",    OB_CONFIG.ammo)
  do_line("\n")

  do_line("-- Custom Mods --\n");
  for name,def in pairs(OB_MODULES) do
    do_line("%s = %s\n", name, sel(def.enabled, "true", "false"))
  end
  do_line("\n")

  do_line("-- Custom Options --\n");
  for name,def in pairs(OB_OPTIONS) do
    do_line("%s = %s\n", name, sel(def.enabled, "true", "false"))
  end
  do_line("\n")
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

