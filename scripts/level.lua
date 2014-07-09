------------------------------------------------------------------------
--  LEVEL MANAGEMENT
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2014 Andrew Apted
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

--[[ *** CLASS INFORMATION ***

class LEVEL
{
  -- FIXME: check this

  name : string  -- engine name for this level, e.g. MAP01

  description : string  -- level name or title (optional)

  kind  -- keyword: "NORMAL", "BOSS", "SECRET"

  episode : EPISODE

  epi_along : float  -- how far along the episode, 0.0 -> 1.0

  rooms   : list(ROOM) 
  scenics : list(ROOM) 
  halls   : list(HALLWAY)

  conns   : list(CONN)
  quests  : list(QUEST)
  locks   : list(LOCK)

  liquid : table  -- the main liquid in the level (can be nil)

  is_dark : bool  -- true if outdoor rooms will be dark

  start_room : ROOM  -- the starting room
   exit_room : ROOM  -- the exit room

  best_conn : table  -- stores the best current connection
                     -- (only used while connecting rooms)

  special : keyword  -- normally nil
                     -- can be: "street", "surround", "wagon"

  hub_links : list(HUB_LINK)  -- hub links which _leave_ this level

  hub_key    : name   -- goal of this level must be this key
  hub_weapon : name   -- weapon to place on this level
  hub_piece  : name   -- weapon PIECE for this level

  assume_weapons : table  -- weapons we got in a previous level

  usable_keys : prob table  -- if present, can only use these keys

  ids : table  -- used for allocating tag numbers (etc)

  -- TODO: lots of other fields : document important ones
}


class EPISODE
{
  levels : list(LEVEL)

  is_hub : boolean  -- 'true' if this episode is a hub

  used_keys : table  -- for hubs, remember keys which have been used
                     -- on any level in the hub (cannot use them again)

  hub_links : list(HUB_LINK)  -- all hub links
}


class HUB_LINK
{
  kind : keyword  -- "chain" or "branch"

  src  : LEVEL
  dest : LEVEL
}


--------------------------------------------------------------]]

require "defs"
require "util"

require "seed"
require "planner"
require "connect"
require "quest"

require "build"
require "prefab"
require "wad_fab"

require "automata"
require "caves"
require "layout"
require "room"

require "fight"
require "monster"
require "naming"


GLOBAL_STYLE_LIST =
{
  -- these two correspond to buttons in the GUI

  outdoors   = { few=20, some=60, heaps=30 }
  caves      = { none=30, few=30, some=30, heaps=7 }

  -- things that affect the whole level

  traps      = { few=20, some=60, heaps=30 }
  secrets    = { few=20, some=50, heaps=10 }
  hallways   = { few=60, some=30, heaps=10 }
  liquids    = { few=30, some=50, heaps=10 }
  scenics    = { few=30, some=50, heaps=10 }
  lakes      = { few=60, heaps=10 }
  islands    = { few=60, heaps=40 }
  sub_rooms  = { none=80, some=30, heaps=5 }

  ambushes    = { none=10, some=50, heaps=10 }
  big_rooms   = { none=20, few=50, some=30, heaps=10 }
  big_juncs   = { none=40, few=30, some=30, heaps=10 }
  cycles      = { none=50, some=50, heaps=50 }
  crossovers  = { none=40 } --!!!! , some=40, heaps=40 }

  mon_variety = { some=90, heaps=4 }
  teleporters = { none=60, few=30, some=30, heaps=5 }
  switches    = { none=5, few=50, some=50, heaps=10 }
  doors       = { none=5, few=50, some=30, heaps=5 }

  room_shape  = { none=80, L=5, T=5, O=5, S=5, X=5 }

  -- things that affect stuff in rooms

  junk       = { few=10, some=60, heaps=30 }
  pillars    = { few=60, some=30, heaps=10 }
  beams      = { few=25, some=50, heaps=5  }
  barrels    = { few=50, some=50, heaps=10 }
  closets    = { few=10, some=30, heaps=30 }

  ex_floors  = { few=40, some=60, heaps=20 }
  windows    = { few=20, some=50, heaps=20 }
  pictures   = { few=10, some=50, heaps=10 }
  steepness  = { few=20, some=60, heaps=10 }

  symmetry   = { none=10, few=40, some=60, heaps=10 }
  cages      = { none=30, few=20, some=20, heaps=10 }
  fences     = { none=30, few=30, some=10 }
  crates     = { none=20, some=40, heaps=10 }

  lt_trim    = { none=40, some=20, heaps=10 }
  lt_spokes  = { none=90, some=20, heaps=5 }
  lt_swapped = { none=90, heaps=20 }
}


COOP_STYLE_LIST =
{
  cycles = { some=30, heaps=50 }
}


GLOBAL_PARAMETERS =
{
  map_limit = 10000

  step_height = 16
  jump_height = 24

  spot_low_h  = 72
  spot_high_h = 128
}


function Levels_clean_up()
  GAME   = {}
  THEME  = {}
  PARAM  = {}
  STYLE  = {}

  LEVEL  = nil
  EPISODE = nil
  SEEDS  = nil

  collectgarbage("collect")
end


function Levels_between_clean()
  LEVEL    = nil
  SEEDS    = nil
  SECTIONS = nil

  collectgarbage("collect")
end


function Levels_merge_themes(theme_tab, tab)
  each name,sub_t in tab do
    if sub_t == REMOVE_ME then
      theme_tab[name] = nil
    elseif not theme_tab[name] then
      theme_tab[name] = table.deep_copy(sub_t)
    else
      table.merge_w_copy(theme_tab[name], sub_t)
    end
  end
end


function Levels_merge_tab(name, tab)
  assert(name and tab)

  if not GAME[name] then
    GAME[name] = table.deep_copy(tab)
    return
  end

  -- special handling for theme tables
  if name == "THEMES" then
    Levels_merge_themes(GAME[name], tab)
    return
  end

  table.merge_w_copy(GAME[name], tab)
end


function Levels_merge_table_list(tab_list)
  each GT in tab_list do
    assert(GT)
    for name,tab in pairs(GT) do
      -- upper-case names should always be tables to copy
      if string.match(name, "^[A-Z]") then
        if type(tab) != "table" then
          error("Game field not a table: " .. tostring(name))
        end
        Levels_merge_tab(name, tab)
      end
    end
  end
end


function Levels_add_game()
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
      Levels_merge_table_list(def.tables)
    end

    if child and def.hooks then
      child.hooks = table.merge_missing(child.hooks or {}, def.hooks)
    end

    if def.format then
      GAME.format = def.format
    end

    return def
  end

  table.insert(GAME.modules, 1, recurse(OB_CONFIG.game))
end


function Levels_add_engine()
  local function recurse(name, child)
    local def = OB_ENGINES[name]

    if not def then
      error("UNKNOWN ENGINE: " .. name)
    end

    if def.extends then
      recurse(def.extends, def)
    end

    if def.tables then
      Levels_merge_table_list(def.tables)
    end

    if child and def.hooks then
      child.hooks = table.merge_missing(child.hooks or {}, def.hooks)
    end

    return def
  end

  table.insert(GAME.modules, 2, recurse(OB_CONFIG.engine))
end


function Levels_sort_modules()
  GAME.modules = {}

  -- find all the visible & enabled modules

  for _,mod in pairs(OB_MODULES) do
    if mod.enabled and mod.shown then
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


function Levels_invoke_hook(name, ...)
  -- two passes, for example: setup and setup2
  for pass = 1,2 do
    for index,mod in ipairs(GAME.modules) do
      local func = mod.hooks and mod.hooks[name]

      if func then
        func(mod, ...)
      end
    end

    name = name .. "2"
  end
end


function Levels_setup()
  Levels_clean_up()

  Levels_sort_modules()

  -- first entry must be the game def, and second entry must be
  -- the engine def.  NOTE: neither of these are real modules.
  Levels_add_game()
  Levels_add_engine()

  -- merge tables from each module

  each mod in GAME.modules do
    if mod.tables then
      Levels_merge_table_list(mod.tables)
    end
  end

  -- allow themes to supply sub-theme information

  for name,theme in pairs(OB_THEMES) do
    if theme.shown and theme.tables then
      Levels_merge_table_list(theme.tables)
    end
  end


  PARAM = assert(GAME.PARAMETERS)

  table.merge_missing(PARAM, GLOBAL_PARAMETERS)


  gui.rand_seed(OB_CONFIG.seed + 0)

  Levels_invoke_hook("setup")


  table.name_up(GAME.ROOMS)
  table.name_up(GAME.THEMES)

  Layout_preprocess_patterns()


  if PARAM.sub_format then
    gui.property("sub_format", PARAM.sub_format)
  end

  gui.property("spot_low_h",  PARAM.spot_low_h)
  gui.property("spot_high_h", PARAM.spot_high_h)
end


function Levels_decide_special_kinds()
  each EPI in GAME.episodes do
    -- TODO
  end

  -- dump the results

  local count = 0

  gui.printf("\nSpecial levels:\n")

  each LEV in GAME.levels do
    if LEV.special then
      gui.printf("  %s : %s\n", LEV.name, LEV.special)
      count = count + 1
    end
  end

  if count == 0 then
    gui.printf("  none\n")
  end
end


function Levels_choose_themes()
  local theme_tab = {}


  local function collect_mixed_themes()
    each name,info in OB_THEMES do
      if info.shown and info.mixed_prob then
        theme_tab[name] = info.mixed_prob
      end
    end

    if table.empty(theme_tab) then
      error("Game is missing usable themes.")
    end
  end


  local function set_level_theme(LEV, name)
    -- don't overwrite theme of special levels
    if LEV.theme_name then
      name = LEV.theme_name
    end

    -- special handling for Psychedelic theme
    if name == "psycho" then
      LEV.psychedelic = true

      if not LEV.name_class and ((LEV.index % 2) == 1) then
        LEV.name_class = "PSYCHO"
      end

      -- pick a real theme to use
      name = rand.key_by_probs(theme_tab)
    end


    local info = assert(OB_THEMES[name])

    LEV.theme_name = name

    if not LEV.name_class then
      LEV.name_class = assert(info.name_class)
    end

    LEV.theme = GAME.THEMES[name .. "_DEFAULTS"]

    if not LEV.theme then
      error("Unknown theme : " .. name)
    end

    gui.printf("Theme for level %s = %s\n", LEV.name, name)
  end


  local function set_single_theme(name)
    each LEV in GAME.levels do
      set_level_theme(LEV, name)
    end
  end


  local function set_jumbled_themes()
    each LEV in GAME.levels do
      set_level_theme(LEV, rand.key_by_probs(theme_tab))
    end
  end


  local function set_mostly_a_theme(theme)
    if not theme_tab[theme] then
      error("Broken mostly_" .. theme .." theme")
    end

    theme_tab[theme] = nil

    local last_same = 0
    local last_diff = 99  -- force first map to be desired theme

    local max_same = 3
    local max_diff = 1

    if OB_CONFIG.length == "game" then
      max_same = 5
      max_diff = 2
    end

    each LEV in GAME.levels do
      local what

      if last_diff >= max_diff then
        what = theme
      elseif (last_same < max_same) and rand.odds(65) then
        what = theme
      else
        what = rand.key_by_probs(theme_tab)
      end

      set_level_theme(LEV, what)

      if what == theme then
        last_same = last_same + 1
        last_diff = 0
      else
        last_diff = last_diff + 1
        last_same = 0
      end
    end
  end


  local function batched_episodic_themes(episode_list)
    local pos = 1
    local count = 0

    each LEV in GAME.levels do
      if count >= 4 or (count >= 2 and rand.odds(50)) then
        pos = pos + 1
        count = 0
      end

      set_level_theme(LEV, episode_list[pos])
      count = count + 1
    end
  end


  local function set_themes_by_episode(episode_list)
    each LEV in GAME.levels do
      set_level_theme(LEV, episode_list[LEV.episode.index])
    end
  end


  local function create_episode_list(total)
    local episode_list = {}

    local tab = table.copy(theme_tab)

    while not table.empty(tab) do
      local name = rand.key_by_probs(tab)
      tab[name] = nil

      local info = OB_THEMES[name]
      local pos = rand.irange(1, total)

      if OB_CONFIG.theme == "original" then
        each epi in GAME.episodes do
          if name == epi.theme and not episode_list[_index] then
            -- this can leave gaps, but they are filled later
            pos = _index ; break
          end
        end
      end

      if episode_list[pos] then
        pos = table.find_unused(episode_list)
      end

      episode_list[pos] = name 
    end

    gui.debugf("Initial theme list = \n%s\n", table.tostr(episode_list))

    -- fill any gaps when in "As Original" mode
    if OB_CONFIG.theme == "original" then
      each epi in GAME.episodes do
        if not episode_list[_index] then
          episode_list[_index] = epi.theme
        end
      end

      assert(# episode_list == total)
    end

    return episode_list
  end


  local function flesh_out_episodes(episode_list, total)
    if total == 2 then
      local dist = rand.sel(70, 0, 1)
      table.insert(episode_list, episode_list[1 + dist])
      table.insert(episode_list, episode_list[2 - dist])
    end

    while #episode_list < 90 do
      table.insert(episode_list, episode_list[rand.irange(1, total)])
    end
  end


  ---| Levels_choose_themes |---

  gui.printf("\n")

  -- need to do this first
  collect_mixed_themes()


  local mostly_theme = string.match(OB_CONFIG.theme, "mostly_(%w+)")

  -- the user can specify the main theme
  if OB_CONFIG.theme != "mixed"    and OB_CONFIG.theme != "jumble" and
     OB_CONFIG.theme != "original" and not mostly_theme
  then
    set_single_theme(OB_CONFIG.theme)
    return
  end


  -- Jumbled Up : every level is purely random
  if OB_CONFIG.theme == "jumble" then
    set_jumbled_themes()
    return
  end

  if mostly_theme then
    set_mostly_a_theme(mostly_theme)
    return
  end


  local total = table.size(theme_tab)

  if OB_CONFIG.theme == "original" then
    total = math.max(total, #GAME.episodes)
  end

  local episode_list = create_episode_list(total)

  gui.printf("Theme for episodes =\n%s\n", table.tostr(episode_list))


  flesh_out_episodes(episode_list, total)

  -- single episode is different : have a few small batches
  if OB_CONFIG.length == "episode" then
    batched_episodic_themes(episode_list)
  end

  set_themes_by_episode(episode_list)
end


function Levels_episode_names()
  each EPI in GAME.episodes do
    -- only generate names for used episodes
    if table.empty(EPI.levels) then continue end

    EPI.description = Naming_grab_one("EPISODE")
  end
end


function Levels_do_styles()
  local style_tab = table.copy(GLOBAL_STYLE_LIST)

  -- adjust styles for Co-operative multiplayer
  if OB_CONFIG.mode == "coop" then
    table.merge(style_tab, COOP_STYLE_LIST)
  end

  -- per game, per level and per theme style_lists
  if GAME.STYLE_LIST then
    table.merge(style_tab, GAME.STYLE_LIST)
  end
  if LEVEL.style_list then
    table.merge(style_tab, LEVEL.style_list)
  end
  if THEME.style_list then
    table.merge(style_tab, THEME.style_list)
  end

  -- decide the values
  STYLE = {}

  for name,prob_tab in pairs(style_tab) do
    STYLE[name] = rand.key_by_probs(prob_tab)
  end

  -- GUI overrides...
  each name in { "outdoors", "caves", "traps" } do
    if OB_CONFIG[name] and OB_CONFIG[name] != "mixed" then
      STYLE[name] = OB_CONFIG[name]
    end
  end

  -- if level needs a secret exit, make lots of secrets
  -- (this is not strictly necessary, more an aesthetic choice)
  if LEVEL.secret_exit then
    STYLE.secrets = "heaps"
  end

  SKY_H = rand.sel(5, 768, 512)

  if LEVEL.psychedelic then
    Mat_prepare_trip()
  end
end


function Levels_build_it()
  -- does the level have a custom build function?
  if LEVEL.build_func then
    LEVEL.build_func()
    if gui.abort() then return "abort" end
    return "ok"
  end

  -- Hexagonal-DM test
  if OB_CONFIG.hex_dm then
    Hex_create_level()
    if gui.abort() then return "abort" end
    return "ok"
  end

  Plan_create_rooms()
  if gui.abort() then return "abort" end

  Connect_rooms()
  if gui.abort() then return "abort" end

  Quest_make_quests()
  if gui.abort() then return "abort" end

  Room_build_all()
  if gui.abort() then return "abort" end

  Monster_make_battles()
  if gui.abort() then return "abort" end

  return "ok"
end


function Levels_handle_prebuilt()
  -- randomly pick one
  local probs = {}

  each info in LEVEL.prebuilt do
    probs[_index] = info.prob or 50
  end

  local info = LEVEL.prebuilt[rand.index_by_probs(probs)]

  assert(info)
  assert(info.file)
  assert(info.map)

  if GAME.format == "doom" then
    gui.wad_transfer_map(info.file, info.map, LEVEL.name)
  else
    -- FIXME: support other games (Wolf3d, Quake, etc)
  end

  return "ok"
end


function Levels_make_level(LEV)
  assert(LEV)
  assert(LEV.name)

  local index = LEV.index
  local total = #GAME.levels

  -- debugging aid : ability to build only a particular level
  if OB_CONFIG.only and
     string.lower(OB_CONFIG.only) != string.lower(LEV.name)
  then
    gui.printf("\nSkipping level: %s....\n\n", LEV.name)
    return
  end

  -- must create the description before the copy (else games/modules won't see it)
  if not LEV.description and LEV.name_class then
    LEV.description = Naming_grab_one(LEV.name_class)
  end

  -- copy level info, so that all new information added into the LEVEL
  -- object by the generator can be garbage collected once this level is
  -- finished.
  LEVEL = table.copy(LEV)

  gui.at_level(LEVEL.name, index, total)

  gui.printf("\n\n~~~~~~| %s |~~~~~~\n", LEVEL.name)

  LEVEL.seed = OB_CONFIG.seed + index * 10
  LEVEL.ids  = {}

  THEME = table.copy(assert(LEVEL.theme))

  if GAME.THEMES.DEFAULTS then
    table.merge_missing(THEME, GAME.THEMES.DEFAULTS)
  end

  --!!!! FIXME: BIG HACK !!!!
  table.merge_missing(THEME, V3_THEME_DEFAULTS)


  gui.rand_seed(LEVEL.seed + 0)


  -- use a pre-built level ?

  if LEVEL.prebuilt then
    Levels_invoke_hook("begin_level")

    local res = Levels_handle_prebuilt()
    if res != "ok" then
      return res
    end

    Levels_invoke_hook("end_level")
    return "ok"
  end


  gui.begin_level()
  gui.property("level_name", LEVEL.name);

  gui.rand_seed(LEVEL.seed + 1)

  Levels_do_styles()

  Levels_invoke_hook("begin_level")

  gui.printf("\nStyles = \n%s\n\n", table.tostr(STYLE, 1))


  local error_mat = assert(GAME.MATERIALS["_ERROR"])

  gui.property("error_tex",  error_mat.t)
  gui.property("error_flat", error_mat.f or error_mat.t)

  if LEVEL.description then
    gui.property("description", LEVEL.description)
  end


  gui.rand_seed(LEVEL.seed + 2)

  local res = Levels_build_it()
  if res != "ok" then
    return res
  end


  Levels_invoke_hook("end_level")

  if LEVEL.sky_bright then gui.property("sky_bright", LEVEL.sky_bright) end
  if LEVEL.sky_shade  then gui.property("sky_shade",  LEVEL.sky_shade)  end

  gui.end_level()


  if index < total then
    Levels_between_clean()
  end

  if gui.abort() then return "abort" end

  return "ok"
end


function Levels_make_all()
  GAME.levels   = {}
  GAME.episodes = {}

  gui.rand_seed(OB_CONFIG.seed + 1)

  Levels_invoke_hook("get_levels")

  if #GAME.levels == 0 then
    error("Level list is empty!")
  end

  table.index_up(GAME.levels)
  table.index_up(GAME.episodes)


  gui.rand_seed(OB_CONFIG.seed + 2)

  Levels_choose_themes()


  gui.rand_seed(OB_CONFIG.seed + 3)

  Levels_decide_special_kinds()

  Levels_episode_names()


  each EPI in GAME.episodes do
    EPISODE = EPI

    each LEV in EPI.levels do
      LEV.allowances = {}

      if Levels_make_level(LEV) == "abort" then
        return "abort"
      end
    end
  end

  Levels_invoke_hook("all_done")

  return "ok"
end

