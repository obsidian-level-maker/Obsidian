------------------------------------------------------------------------
--  OBLIGE  :  INTERFACE WITH GUI CODE
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2017 Andrew Apted
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
------------------------------------------------------------------------

gui.import("defs")
gui.import("util")
gui.import("brush")
gui.import("prefab")

gui.import("seed")
gui.import("rules")
gui.import("grower")
gui.import("area")
gui.import("connect")
gui.import("quest")

gui.import("automata")
gui.import("cave")
gui.import("layout")
gui.import("render")
gui.import("boss_map")
gui.import("room")

gui.import("fight")
gui.import("monster")
gui.import("item")
gui.import("naming")
gui.import("title_gen")
gui.import("level")


function ob_traceback(msg)

  -- guard against very early errors
  if not gui or not gui.printf then
    return msg
  end

  gui.printf("\n")
  gui.printf("@1****** ERROR OCCURRED ******\n\n")
  gui.printf("Stack Trace:\n")

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

      if info.namewhat and info.namewhat != "" then
        func_name = info.name or "???"
      else
        -- perform our own search of the global namespace,
        -- since the standard LUA code (5.1.2) will not check it
        -- for the topmost function (the one called by C code)
        each k,v in _G do
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

      if info.namewhat and info.namewhat != "" then
        gui.printf("  %d: c-function %s()\n", i, info.name or "???")
      end
    end
  end

  return msg
end



function ob_ref_table(op, t)
  if not gui.___REFS then
    gui.___REFS = {}
  end

  if op == "clear" then
    gui.___REFS = {}
    collectgarbage("collect")
    return
  end

  if op == "store" then
    if t == _G then return 0 end
    local id = 1 + #gui.___REFS
    gui.___REFS[id] = t    -- t == table
    return id
  end

  if op == "lookup" then
    if t == 0 then return _G end
    return gui.___REFS[t]  -- t == id number
  end

  error("ob_ref_table: unknown op: " .. tostring(op))
end


------------------------------------------------------------------------


function ob_check_ui_module(def)
  return string.match(def.name, "^ui") != nil
end



function ob_match_word_or_table(tab, conf)
  if type(tab) == "table" then
    return tab[conf] and tab[conf] > 0
  else
    return tab == conf
  end
end



function ob_match_game(T)
  if not T.game then return true end
  if T.game == "any" then return true end

  -- special check: if required game is "doomish" then allow any
  -- of the DOOM games to match.
  if T.game == "doomish" then
     T.game = { doom1=1, doom2=1 }
  end

  local game   = T.game
  local result = true

  -- negated check?
  if type(game) == "string" and string.sub(game, 1, 1) == '!' then
    game   = string.sub(game, 2)
    result = not result
  end

  -- normal check
  if ob_match_word_or_table(game, OB_CONFIG.game) then
    return result
  end

  -- handle extended games
  local game_def = OB_GAMES[OB_CONFIG.game]

  while game_def do
    if not game_def.extends then
      break;
    end

    if ob_match_word_or_table(game, game_def.extends) then
      return result
    end

    game_def = OB_GAMES[game_def.extends]
  end

  return not result
end


function ob_match_engine(T)
  if not T.engine then return true end
  if T.engine == "any" then return true end

  local engine = T.engine
  local result = true

  -- negated check?
  if type(engine) == "string" and string.sub(engine, 1, 1) == '!' then
    engine = string.sub(engine, 2)
    result = not result
  end

  -- normal check
  if ob_match_word_or_table(engine, OB_CONFIG.engine) then
    return result
  end

  -- handle extended engines

  local engine_def = OB_ENGINES[OB_CONFIG.engine]

  while engine_def do
    if not engine_def.extends then
      break;
    end

    if ob_match_word_or_table(engine, engine_def.extends) then
      return result
    end

    engine_def = OB_ENGINES[engine_def.extends]
  end

  return not result
end


function ob_match_playmode(T)
  -- TODO : remove this function

  return true
end


function ob_match_level_theme(T)
  if not T.theme then return true end
  if T.theme == "any" then return true end

  local theme  = T.theme
  local result = true

  -- negated check?
  if type(theme) == "string" and string.sub(theme, 1, 1) == '!' then
    theme  = string.sub(theme, 2)
    result = not result
  end

  -- normal check
  if ob_match_word_or_table(theme, LEVEL.theme_name) then
    return result
  end

  return not result
end


function ob_match_module(T)
  if not T.module then return true end

  local mod_tab = T.module

  if type(mod_tab) != "table" then
    mod_tab  = { [T.module]=1 }
    T.module = mod_tab
  end

  -- require ALL specified modules to be present and enabled

  each name,_ in mod_tab do
    local def = OB_MODULES[name]

    if not (def and def.shown and def.enabled) then
      return false
    end
  end

  return true
end


function ob_match_feature(T)
  if not T.feature then return true end

  local feat_tab = T.feature

  if type(feat_tab) != "table" then
    feat_tab  = { [T.feature]=1 }
    T.feature = feat_tab
  end

  -- require ALL specified features to be available

  each name,_ in feat_tab do
    local param = PARAM[name]

    if param == nil or param == false then
      return false
    end
  end

  return true
end



function ob_match_conf(T)
  assert(OB_CONFIG.game)
  assert(OB_CONFIG.engine)

  if not ob_match_game(T)     then return false end
  if not ob_match_engine(T)   then return false end
  if not ob_match_module(T)   then return false end

  return true --OK--
end



function ob_update_engines()
  local need_new = false

  each name,def in OB_ENGINES do
    local shown = ob_match_conf(def)

    if not shown and (OB_CONFIG.engine == name) then
      need_new = true
    end

    gui.enable_choice("engine", name, shown)
  end

  if need_new then
    OB_CONFIG.engine = "nolimit"
    gui.set_button("engine", OB_CONFIG.engine)
  end
end



function ob_update_themes()
  local new_label

  each name,def in OB_THEMES do
    local shown = ob_match_conf(def)

    if not shown and (OB_CONFIG.theme == name) then
      new_label = def.label
    end

    def.shown = shown
    gui.enable_choice("theme", name, def.shown)
  end

  -- try to keep the same GUI label
  if new_label then
    each name,def in OB_THEMES do
      local shown = ob_match_conf(def)

      if shown and def.label == new_label then
        OB_CONFIG.theme = name
        gui.set_button("theme", OB_CONFIG.theme)
        return
      end
    end

    -- otherwise revert to As Original
    OB_CONFIG.theme = "original"
    gui.set_button("theme", OB_CONFIG.theme)
  end
end



function ob_update_modules()
  -- modules may depend on other modules, hence we may need
  -- to repeat this multiple times until all the dependencies
  -- have flowed through.

  for loop = 1,100 do
    local changed = false

    each name,def in OB_MODULES do
      local shown = ob_match_conf(def)

      if shown != def.shown then
        changed = true
      end

      def.shown = shown
      gui.show_module(name, def.shown)
    end

    if not changed then break; end
  end
end



function ob_update_all()
  ob_update_engines()
  ob_update_modules()
  ob_update_themes()
end



function ob_find_mod_option(mod, opt_name)
  if not mod.options then return nil end

  -- if 'options' is a list, search it one-by-one
  if mod.options[1] then
    each opt in mod.options do
      if opt.name == opt_name then
        return opt
      end
    end
  end

  return mod.options[opt_name]
end


function ob_defs_conflict(def1, def2)
  if not def1.conflicts then return false end
  if not def2.conflicts then return false end

  each name,_ in def1.conflicts do
    if def2.conflicts[name] then
      return true
    end
  end

  return false
end


function ob_set_mod_option(name, option, value)
  local mod = OB_MODULES[name]
  if not mod then
    gui.printf("Ignoring unknown module: %s\n", name)
    return
  end

  if option == "self" then
    -- convert 'value' from string to a boolean
    value = not (value == "false" or value == "0")

    if mod.enabled == value then
      return -- no change
    end

    mod.enabled = value

    -- handle conflicting modules (like Radio buttons)
    if value then
      each other,odef in OB_MODULES do
        if odef != mod and ob_defs_conflict(mod, odef) then
          odef.enabled = false
          gui.set_module(other, odef.enabled)
        end
      end
    end

    -- this is required for parsing the CONFIG.TXT file
    -- [but redundant when the user merely changed the widget]
    gui.set_module(name, mod.enabled)

    ob_update_all()
    return
  end


  local opt = ob_find_mod_option(mod, option)
  if not opt then
    gui.printf("Ignoring unknown option: %s.%s\n", name, option)
    return
  end

  -- this can only happen while parsing the CONFIG.TXT file
  -- (containing some no-longer-used value).
  if not opt.avail_choices[value] then
    warning("invalid choice: %s (for option %s.%s)\n", value, name, option)
    return
  end

  opt.value = value

  gui.set_module_option(name, option, value)

  -- no need to call ob_update_all
  -- (nothing ever depends on custom options)
end



function ob_set_config(name, value)
  -- See the document 'doc/Config_Flow.txt' for a good
  -- description of the flow of configuration values
  -- between the C++ GUI and the Lua scripts.

  assert(name and value and type(value) == "string")

  if name == "seed" then
    OB_CONFIG[name] = tonumber(value) or 0
    return
  end


  -- check all the UI modules for a matching option
  -- [ this is only needed when parsing the CONFIG.txt file ]
  each _,mod in OB_MODULES do
    if ob_check_ui_module(mod) then
      each opt in mod.options do
        if opt.name == name then
          ob_set_mod_option(mod.name, name, value)
          return
        end
      end
    end
  end


  if OB_CONFIG[name] and OB_CONFIG[name] == value then
    return -- no change
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

  if name == "game" or name == "engine" then
    ob_update_all()
  end

  -- this is required for parsing the CONFIG.TXT file
  -- [ but redundant when the user merely changed the widget ]
  if name == "game"  or name == "engine" or
     name == "theme" or name == "length"
  then
    gui.set_button(name, OB_CONFIG[name])
  end
end



function ob_read_all_config(need_full, log_only)

  local function do_line(fmt, ...)
    if log_only then
      gui.printf(fmt .. "\n", ...)
    else
      gui.config_line(string.format(fmt, ...))
    end
  end

  local function do_value(name, value)
    do_line("%s = %s", name, value or "XXX")
  end

  local function do_mod_value(name, value)
    do_line("  %s = %s", name, value or "XXX")
  end

  ---| ob_read_all_config |---

  -- workaround for a limitation in C++ code
  if need_full == "" then
     need_full = false
  end

  if OB_CONFIG.seed and OB_CONFIG.seed != 0 then
    do_line("seed = %d",   OB_CONFIG.seed)
    do_line("")
  end

  do_line("---- Game Settings ----")
  do_line("")

  do_value("game",     OB_CONFIG.game)
  do_value("engine",   OB_CONFIG.engine)
  do_value("length",   OB_CONFIG.length)
  do_value("theme",    OB_CONFIG.theme)

  do_line("")

  -- the UI modules/panels use bare option names
  each name in table.keys_sorted(OB_MODULES) do
    local def = OB_MODULES[name]

    if ob_check_ui_module(def) then
      do_line("---- %s ----", def.label)
      do_line("")

      each opt in def.options do
        do_value(opt.name, opt.value)
      end

      do_line("")
    end
  end

  do_line("---- Other Modules ----")
  do_line("")

  each name in table.keys_sorted(OB_MODULES) do
    local def = OB_MODULES[name]

    if ob_check_ui_module(def) then continue end

    if not need_full and not def.shown then continue end

    do_line("@%s = %s", name, sel(def.enabled, "1", "0"))

    -- module options
    if need_full or def.enabled then
      if def.options and not table.empty(def.options) then
        if def.options[1] then
          each opt in def.options do
            do_mod_value(opt.name, opt.value)
          end
        else
          each o_name,opt in def.options do
            do_mod_value(o_name, opt.value)
          end
        end
      end
    end

    do_line("")
  end

  do_line("-- END --")
end



function ob_load_game(game)
  -- 'game' parameter must be a sub-directory of the games/ folder

  -- ignore the template game -- it is only instructional
  if game == "template" then return end

  gui.debugf("  %s\n", game)

  gui.set_import_dir("games/" .. game)

  -- the base script will import even more script files
  gui.import("base")

  gui.set_import_dir("")
end


function ob_load_all_games()
  gui.printf("Loading all games...\n")

  local list = gui.scan_directory("games", "DIRS")

  if not list then
    error("Failed to scan 'games' directory")
  end

  if OB_CONFIG.only_game then
    gui.printf("Only loading one game: '%s'\n", OB_CONFIG.only_game)
    ob_load_game(OB_CONFIG.only_game)
  else
    each game in list do
      ob_load_game(game)
    end
  end

  if table.empty(OB_GAMES) then
    error("Failed to load any games at all")
  end
end


function ob_load_all_engines()
  gui.printf("Loading all engines...\n")

  local list = gui.scan_directory("engines", "*.lua")

  if not list then
    gui.printf("FAILED: scan 'engines' directory\n")
    return
  end

  gui.set_import_dir("engines")

  each filename in list do
    gui.debugf("  %s\n", filename)
    gui.import(filename)
  end

  gui.set_import_dir("")
end


function ob_load_all_modules()
  gui.printf("Loading all modules...\n")

  local list = gui.scan_directory("modules", "*.lua")

  if not list then
    gui.printf("FAILED: scan 'modules' directory\n")
    return
  end

  gui.set_import_dir("modules")

  each filename in list do
    gui.debugf("  %s\n", filename)
    gui.import(filename)
  end

  gui.set_import_dir("")
end



function ob_init()

  -- the missing print functions
  gui.printf = function (fmt, ...)
    if fmt then gui.raw_log_print(string.format(fmt, ...)) end
  end

  gui.debugf = function (fmt, ...)
    if fmt then gui.raw_debug_print(string.format(fmt, ...)) end
  end


  gui.printf("~~ Oblige Lua initialization begun ~~\n\n")


  -- load definitions for all games

  ob_load_all_games()
  ob_load_all_engines()
  ob_load_all_modules()


  table.name_up(OB_GAMES)
  table.name_up(OB_THEMES)
  table.name_up(OB_ENGINES)
  table.name_up(OB_MODULES)


  local function preinit_all(DEFS)
    local removed = {}

    each name,def in DEFS do
      if def.preinit_func then
        if def.preinit_func(def) == REMOVE_ME then
          table.insert(removed, name)
        end
      end
    end

    each name in removed do
      DEFS[name] = nil
    end
  end

  preinit_all(OB_GAMES)
  preinit_all(OB_THEMES)
  preinit_all(OB_ENGINES)
  preinit_all(OB_MODULES)


  local function button_sorter(A, B)
    if A.priority or B.priority then
      return (A.priority or 50) > (B.priority or 50)
    end

    return A.label < B.label
  end


  local function create_buttons(what, DEFS)
    assert(DEFS)
    gui.debugf("creating buttons for %s\n", what)

    local list = {}

    local min_priority = 999

    each name,def in DEFS do
      assert(def.name and def.label)
      table.insert(list, def)
      min_priority = math.min(min_priority, def.priority or 50)
    end

    -- add separators for the Game, Engine and Theme menus
    if what == "game" and min_priority < 49 then
      table.insert(list, { priority=49, name="_", label="_" })
    end

    if what == "engine" and min_priority < 92 then
      table.insert(list, { priority=92, name="_", label="_" })
    end

    if what == "theme" and min_priority < 79 then
      table.insert(list, { priority=79, name="_", label="_" })
    end

    table.sort(list, button_sorter)

    each def in list do
      if what == "module" then
        local where = def.side or "right"

        gui.add_module(where, def.name, def.label, def.tooltip)
      else
        gui.add_choice(what, def.name, def.label)
      end

      -- TODO : review this, does it belong HERE ?
      if what == "game" then
        gui.enable_choice("game", def.name, true)
      end
    end

    -- set the current value
    if what != "module" then
      local default = list[1] and list[1].name

      OB_CONFIG[what] = default
    end
  end


  local function simple_buttons(what, choices, default)
    for i = 1,#choices,2 do
      local id    = choices[i]
      local label = choices[i+1]

      gui.   add_choice(what, id, label)
      gui.enable_choice(what, id, true)
    end

    OB_CONFIG[what] = default
  end


  local function create_mod_options()
    gui.debugf("creating module options\n", what)

    each _,mod in OB_MODULES do
      if not mod.options then
        mod.options = {}
      else
        local list = mod.options

        -- handle lists (for UI modules) different from key/value tables
        if list[1] == nil then
          list = {}

          each name,opt in mod.options do
            opt.name = name
            table.insert(list, opt)
          end

          table.sort(list, button_sorter)
        end

        each opt in list do
          assert(opt.label)
          assert(opt.choices)

          gui.add_module_option(mod.name, opt.name, opt.label, opt.tooltip, opt.gap)

          opt.avail_choices = {}

          for i = 1,#opt.choices,2 do
            local id    = opt.choices[i]
            local label = opt.choices[i+1]

            gui.add_option_choice(mod.name, opt.name, id, label)
            opt.avail_choices[id] = 1
          end

          -- select a default value
          if not opt.default then
                if opt.avail_choices["default"] then opt.default = "default"
            elseif opt.avail_choices["normal"]  then opt.default = "normal"
            elseif opt.avail_choices["medium"]  then opt.default = "medium"
            elseif opt.avail_choices["mixed"]   then opt.default = "mixed"
            else   opt.default = opt.choices[1]
            end
          end

          opt.value = opt.default

          gui.set_module_option(mod.name, opt.name, opt.value)
        end -- for opt
      end
    end -- for mod
  end


  OB_CONFIG.seed = 0

  create_buttons("game",   OB_GAMES)
  create_buttons("engine", OB_ENGINES)
  create_buttons("theme",  OB_THEMES)

  simple_buttons("length",   LENGTH_CHOICES,   "game")

  create_buttons("module", OB_MODULES)
  create_mod_options()

  ob_update_all()

  gui.set_button("game",     OB_CONFIG.game)
  gui.set_button("engine",   OB_CONFIG.engine)
  gui.set_button("length",   OB_CONFIG.length)
  gui.set_button("theme",    OB_CONFIG.theme)

  gui.printf("\n~~ Completed Lua initialization ~~\n\n")
end



function ob_game_format()
  assert(OB_CONFIG)
  assert(OB_CONFIG.game)

  local game = OB_GAMES[OB_CONFIG.game]

  assert(game)

  if game.extends then
    game = assert(OB_GAMES[game.extends])
  end

  return assert(game.format)
end


------------------------------------------------------------------------


function ob_merge_tab(name, tab)
  assert(name and tab)

  if not GAME[name] then
    GAME[name] = table.deep_copy(tab)
    return
  end

  -- support replacing _everything_
  -- [ needed mainly for Doom 1 themes ]
  if tab.replace_all then
    GAME[name] = {}
  end

  table.merge_w_copy(GAME[name], tab)

  GAME[name].replace_all = nil
end


function ob_merge_table_list(tab_list)
  each GT in tab_list do
    assert(GT)
    each name,tab in GT do
      -- upper-case names should always be tables to copy
      if string.match(name, "^[A-Z]") then
        if type(tab) != "table" then
          error("Game field not a table: " .. tostring(name))
        end
        ob_merge_tab(name, tab)
      end
    end
  end
end



function ob_add_current_game()
  local function recurse(name, child)
    local def = OB_GAMES[name]

    if not def then
      error("UNKNOWN GAME: " .. name)
    end

    -- here is the tricky bit : by recursing now, we can process all the
    -- definitions in the correct order (children after parents).

    if def.extends then
      recurse(def.extends, def)
    end

    if def.tables then
      ob_merge_table_list(def.tables)
    end

    if child and def.hooks then
      child.hooks = table.merge_missing(child.hooks or {}, def.hooks)
    end

    each keyword in { "format", "sub_format", "game_dir" } do
      if def[keyword] != nil then
        GAME[keyword] = def[keyword]
      end
    end

    return def
  end

  table.insert(GAME.modules, 1, recurse(OB_CONFIG.game))
end



function ob_add_current_engine()
  local function recurse(name, child)
    local def = OB_ENGINES[name]

    if not def then
      error("UNKNOWN ENGINE: " .. name)
    end

    if def.extends then
      recurse(def.extends, def)
    end

    if def.tables then
      ob_merge_table_list(def.tables)
    end

    if child and def.hooks then
      child.hooks = table.merge_missing(child.hooks or {}, def.hooks)
    end

    return def
  end

  table.insert(GAME.modules, 2, recurse(OB_CONFIG.engine))
end



function ob_sort_modules()
  GAME.modules = {}

  -- find all the visible & enabled modules
  -- [ ignore the special UI modules/panels ]

  each _,mod in OB_MODULES do
    if mod.enabled and mod.shown and not ob_check_ui_module(mod) then
      table.insert(GAME.modules, mod)
    end
  end

  -- sort them : lowest -> highest priority, because later
  -- entries can override things done by earlier ones.

  local function module_sorter(A, B)
    if A.priority or B.priority then
      return (A.priority or 50) < (B.priority or 50)
    end

    return A.label < B.label
  end

  if #GAME.modules > 1 then
    table.sort(GAME.modules, module_sorter)
  end
end



function ob_invoke_hook(name, ...)
  -- two passes, for example: setup and setup2
  for pass = 1,2 do
    each mod in GAME.modules do
      local func = mod.hooks and mod.hooks[name]

      if func then
        func(mod, ...)
      end
    end

    name = name .. "2"
  end
end



function ob_transfer_ui_options()
  each _,mod in OB_MODULES do
    if ob_check_ui_module(mod) then
      each opt in mod.options do
        OB_CONFIG[opt.name] = opt.value or "UNSET"
      end
    end
  end

  -- fixes for backwards compatibility
  if OB_CONFIG.length == "full" then
     OB_CONFIG.length = "game"
  end

  if OB_CONFIG.theme == "mixed" then
     OB_CONFIG.theme = "epi"
  end

  if OB_CONFIG.size == "tiny" then
     OB_CONFIG.size = "small"
  end
end



function ob_build_setup()
  ob_clean_up()

  ob_transfer_ui_options()

  ob_sort_modules()

  -- first entry in module list *must* be the game def, and second entry
  -- must be the engine definition.  NOTE: neither are real modules!
  ob_add_current_game()
  ob_add_current_engine()

  -- merge tables from each module
  -- [ but skip GAME and ENGINE, which are already merged ]

  each mod in GAME.modules do
    if _index > 2 and mod.tables then
      ob_merge_table_list(mod.tables)
    end
  end


  PARAM = assert(GAME.PARAMETERS)

  table.merge_missing(PARAM, GLOBAL_PARAMETERS)


  -- load all the prefab definitions

  Fab_load_all_definitions()

  Grower_preprocess_grammar()


  gui.rand_seed(OB_CONFIG.seed + 0)

  ob_invoke_hook("setup")


  table.name_up(GAME.THEMES)
  table.name_up(GAME.ROOM_THEMES)
  table.name_up(GAME.ROOMS)


  if GAME.sub_format then
    gui.property("sub_format", GAME.sub_format)
  end

  gui.property("spot_low_h",  PARAM.spot_low_h)
  gui.property("spot_high_h", PARAM.spot_high_h)
end



function ob_clean_up()
  GAME   = {}
  THEME  = {}
  PARAM  = {}
  STYLE  = {}

  LEVEL   = nil
  EPISODE = nil
  PREFABS = nil
  SEEDS   = nil

  collectgarbage("collect")
end



function ob_build_cool_shit()
  assert(OB_CONFIG)
  assert(OB_CONFIG.game)

  gui.printf("\n\n")
  gui.printf("~~~~~~~ Making Levels ~~~~~~~\n\n")

  ob_read_all_config(false, "log_only")

  gui.ticker()

  ob_build_setup()

  local status = Level_make_all()

  ob_clean_up()

  gui.printf("\n")

  if status == "abort" then
    gui.printf("\n")
    gui.printf("~~~~~~~ Build Aborted! ~~~~~~~\n\n")
    return "abort"
  end

  gui.printf("\n")
  gui.printf("~~~~~~ Finished Making Levels ~~~~~~\n\n")

  return "ok"
end

