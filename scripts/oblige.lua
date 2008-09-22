----------------------------------------------------------------
--  Oblige
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

require 'defs'
require 'util'
require 'a_star'
require 'engines'

require 'seeds'
require 'plan_sp'
require 'quests'
require 'rooms'
require 'builder'

-- require 'monsters'


OB_THEMES["mixed"] =
{
  label = "Mix It Up",
  priority = -99,
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


----------------------------------------------------------------
--  FUNCTIONS CALLED FROM GUI CODE
----------------------------------------------------------------

function ob_traceback(msg)

  -- guard against very early errors
  if not gui or not gui.printf then
    return msg
  end
 
  gui.printf("\nStack Trace:\n")

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
      gui.printf("(remaining stack trace omitted)\n")
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

      gui.printf("  %d: %s() %s\n", i, func_name, format_source(info))

    elseif info.what == "main" then

      gui.printf("  %d: main body %s\n", i, format_source(info))

    elseif info.what == "tail" then

      gui.printf("  %d: tail call\n", i)

    elseif info.what == "C" then

      if info.namewhat and info.namewhat ~= "" then
        gui.printf("  %d: c-function %s()\n", i, info.name or "???")
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
  local need_new = false

  for name,def in pairs(OB_ENGINES) do
    local shown = ob_match_conf(def)

    if not shown and (OB_CONFIG.engine == name) then
      need_new = true
    end

    gui.show_button("engine", name, shown)
  end

  if need_new then
    OB_CONFIG.engine = "nolimit"
    gui.change_button("engine", OB_CONFIG.engine)
  end
end


function ob_update_themes()
  local new_label

  for name,def in pairs(OB_THEMES) do
    local shown = ob_match_conf(def)

    if not shown and (OB_CONFIG.theme == name) then
      new_label = def.label
    end

    gui.show_button("theme", name, shown)
  end

  -- try to keep the same GUI label
  if new_label then
    for name,def in pairs(OB_THEMES) do
      local shown = ob_match_conf(def)

      if shown and def.label == new_label then
        OB_CONFIG.theme = name
        gui.change_button("theme", OB_CONFIG.theme)
        return
      end
    end

    -- otherwise revert to Mix It Up
    OB_CONFIG.theme = "mixed"
    gui.change_button("theme", OB_CONFIG.theme)
  end
end


function ob_update_modules()
  -- modules may depend on other modules, hence we may need
  -- to repeat this multiple times until all the dependencies
  -- have flowed through.
  
  for loop = 1,10 do
    local changed = false

    for name,def in pairs(OB_MODULES) do
      local shown = ob_match_conf(def)

      if shown ~= def.shown then
        changes = true
      end

      def.shown = shown
      gui.show_button("module", name, def.shown)
    end

    if not changed then break; end
  end
end


function ob_update_all()
  ob_update_engines()
  ob_update_modules()
  ob_update_themes()
end


function ob_set_config(name, value)
  assert(name and value and type(value) == "string")

  if name == "seed" then
    OB_CONFIG[name] = tonumber(value) or 0
    return
  end


  if OB_MODULES[name] then
    -- convert 'value' from string to a boolean
    value = not (value == "false" or value == "0")

    if OB_MODULES[name].enabled == value then
      return -- no change
    end

    local def = OB_MODULES[name]

    def.enabled = value

    -- handle conflicting modules (like Radio buttons)
    if value then
      for other,odef in pairs(OB_MODULES) do
        if ( def.conflict_mods and  def.conflict_mods[other]) or
           (odef.conflict_mods and odef.conflict_mods[name] )
        then
          odef.enabled = false
          gui.change_button("module", other, odef.enabled)
        end
      end
    end

    -- this is required for parsing the CONFIG.CFG file
    -- [but redundant when the user merely changed the widget]
    gui.change_button("module", name, def.enabled)

    ob_update_all()
    return
  end


  -- handle OPTIONS
  if string.find(name, ".", 1, true) then
    
    local mod, opt = string.match(name, "([%w_]*).([%w_]*)")
    assert(mod and opt)

    local mod_def = OB_MODULES[mod]
    if not mod_def then
      gui.printf("Ignoring unknown module: %s (for option)\n", mod)
      return
    end

    local def = mod_def.options and mod_def.options[opt]
    if not def then
      gui.printf("Ignoring unknown option: %s.%s\n", mod, opt)
      return
    end

    if not def.choices[value] then
      gui.printf("Ignoring invalid choice: %s (for %s.%s)\n",
                 value, mod, opt)
      return
    end

    def.value = value

    -- no need to call ob_update_all
    -- (nothing ever depends on custom options)
    return
  end


  if OB_CONFIG[name] and OB_CONFIG[name] == value then
    return
  end


  -- validate some important variables
  if name == "game" then
    assert(OB_CONFIG.game)
    if not OB_GAMES[value] then
      gui.printf("Ignoring unknown game: %s\n", value)
      return
    end
  elseif name == "engine" then
    assert(OB_CONFIG.engine)
    if not OB_ENGINES[value] then
      gui.printf("Ignoring unknown engine: %s\n", value)
      return
    end
  elseif name == "theme" then
    assert(OB_CONFIG.theme)
    if not OB_THEMES[value] then
      gui.printf("Ignoring unknown theme: %s\n", value)
      return
    end
  end

  OB_CONFIG[name] = value

  if (name == "game") or (name == "mode") or (name == "engine") then
    ob_update_all()
  end

  -- this is required for parsing the CONFIG.CFG file
  -- [but redundant when the user merely changed the widget]
  if (name == "game") or (name == "engine") or (name == "theme") then
    gui.change_button(name, OB_CONFIG[name])
  end
end


function ob_read_all_config(all_options)
all_options = true --!!!!

  local function do_line(fmt, ...)
    gui.config_line(string.format(fmt, ...))
  end

  do_line("-- Game Settings --");

  do_line("seed = %d",   OB_CONFIG.seed or 0)
  do_line("game = %s",   OB_CONFIG.game)
  do_line("mode = %s",   OB_CONFIG.mode)
  do_line("engine = %s", OB_CONFIG.engine)
  do_line("length = %s", OB_CONFIG.length)
  do_line("")

  do_line("-- Level Architecture --");
  do_line("theme = %s",   OB_CONFIG.theme)
  do_line("size = %s",    OB_CONFIG.size)
  do_line("detail = %s",  OB_CONFIG.detail)
  do_line("heights = %s", OB_CONFIG.heights)
  do_line("light = %s",   OB_CONFIG.light)
  do_line("")

  do_line("-- Playing Style --");
  do_line("mons = %s",    OB_CONFIG.mons)
  do_line("puzzles = %s", OB_CONFIG.puzzles)
  do_line("traps = %s",   OB_CONFIG.traps)
  do_line("health = %s",  OB_CONFIG.health)
  do_line("ammo = %s",    OB_CONFIG.ammo)
  do_line("")

  do_line("-- Custom Mods --");
  for name,def in pairs(OB_MODULES) do
    do_line("%s = %s", name, sel(def.enabled, "true", "false"))
  end
  do_line("")

  do_line("-- Custom Options --");
  for name,def in pairs(OB_MODULES) do
    if def.options and (all_options or def.enabled) then
      for o_name,opt in pairs(def.options) do
        do_line("%s.%s = %s", name, o_name, opt.value or "XXX")
      end
    end
  end
  do_line("")
end


function ob_init()

  -- the missing console functions
  gui.printf = function (fmt, ...)
    if fmt then gui.raw_log_print(string.format(fmt, ...)) end
  end

  gui.debugf = function (fmt, ...)
    if fmt then gui.raw_debug_print(string.format(fmt, ...)) end
  end

  name_it_up(OB_GAMES)
  name_it_up(OB_THEMES)
  name_it_up(OB_ENGINES)
  name_it_up(OB_MODULES)


  local function button_sorter(A, B)
    if A.priority or B.priority then
      return (A.priority or 0) > (B.priority or 0)
    end

    return A.label < B.label
  end

  local function create_buttons(what, DEFS, show_em)
    assert(DEFS)
  
    local list = {}

    for name,def in pairs(DEFS) do
      assert(def.name and def.label)
      table.insert(list, def)
    end

    table.sort(list, button_sorter)

    for xxx,def in ipairs(list) do
      gui.add_button(what, def.name, def.label)

      if what == "game" then
        gui.show_button(what, def.name, true)
      end
    end

    return list[1] and list[1].name
  end

  local function create_mod_options()
    for _,mod in pairs(OB_MODULES) do
      if not mod.options then
        mod.options = {}
      end

      name_it_up(mod.options)

      for _,opt in pairs(mod.options) do
        assert(opt.label)
        assert(opt.choices)

        gui.add_mod_option(mod.name, opt.name, opt.label)

        -- default value is always the first choice
        opt.value = opt.choices[1].id

        for N = 1,#opt.choices do
          gui.add_mod_option(mod.name, opt.name,
                             opt.choices[N].id,
                             opt.choices[N].label)
        end
      end -- for opt
    end -- for mod
  end

  OB_CONFIG.seed = 0
  OB_CONFIG.mode = "sp" -- GUI code sets the real default

  OB_CONFIG.game   = create_buttons("game",   OB_GAMES)
  OB_CONFIG.engine = create_buttons("engine", OB_ENGINES)
  OB_CONFIG.theme  = create_buttons("theme",  OB_THEMES)

  create_buttons("module", OB_MODULES)
  create_mod_options()

  ob_update_all()

  gui.change_button("game",   OB_CONFIG.game)
  gui.change_button("engine", OB_CONFIG.engine)
end


function ob_game_format()

  assert(OB_CONFIG)
  assert(OB_CONFIG.game)

  return OB_GAMES[OB_CONFIG.game]["format"]
end


function build_cool_shit()
 
  assert(OB_CONFIG)
  assert(OB_CONFIG.game)

  gui.printf("\n\n~~~~~~~ Making Levels ~~~~~~~\n\n")

  gui.printf("SEED = %d\n\n", OB_CONFIG.seed)
  gui.printf("Settings =\n%s\n", table_to_str(OB_CONFIG))

  gui.ticker()


-- [[ PLANNING TEST CODE
local NUM = 1
  if OB_CONFIG.length == "episode" then
    NUM = 10
  elseif OB_CONFIG.length == "full" then
    NUM = 30
  end

for level = 1,NUM do

  gui.rand_seed(OB_CONFIG.seed * 100 + level)

  local level_name = string.format("MAP%02d", level)

  gui.printf("\n\n~~~~~~| %s |~~~~~~\n", level_name)

  gui.at_level(level_name, level, NUM)

  local epi_along = ((level - 1) % 10) / 9

  Plan_rooms_sp(epi_along)
    if gui.abort() then return "abort" end
    gui.progress(20)

  Quest_assign()
    if gui.abort() then return "abort" end
    gui.progress(40)

--!!!!!!  Rooms_fit_out()
    if gui.abort() then return "abort" end
    gui.progress(60)

  Seed_grow()

  dummy_builder(level_name)
    if gui.abort() then return "abort" end
    gui.progress(100)
end

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

  if aborted then
    gui.printf("\n~~~~~~~ Build Aborted! ~~~~~~~\n\n")
    return "abort"
  end

  gui.printf("\n~~~~~~ Finished Making Levels ~~~~~~\n\n")

  return "ok"
end

