----------------------------------------------------------------
--  LEVEL MANAGEMENT
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2010 Andrew Apted
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
  -- FIXME: check this

  name : string  -- engine name for this level, e.g. MAP01

  epi_along : float  -- how far along the episode, 0.0 -> 1.0

  rooms  : list(ROOM) 
  conns  : list(CONN)
  quests : list(QUEST)
  locks  : list(LOCK)

  last_tag  : number
  last_mark : number
  last_room : number
  
  -- TODO: lots of other fields : document important ones
}


--------------------------------------------------------------]]

require 'defs'
require 'util'

require 'planner'
require 'connect'
require 'quests'
require 'caves'

require 'seeds'
require 'build'
require 'chunks'
require 'simple'
require 'hallway'
require 'areas'

require 'rooms'
require 'fight'
require 'monsters'
require 'naming'


GLOBAL_STYLE_LIST =
{
  skies      = { few=20, some=60, heaps=40 }
  hallways   = { few=10, some=90, heaps=30 }
  liquids    = { few=30, some=50, heaps=20 }
  scenics    = { few=30, some=50, heaps=10 }
  naturals   = { none=10, few=30, some=60, heaps=4 }
  big_rooms  = { none=3, few=40, some=40, heaps=20 }
  lakes      = { few=60, heaps=10 }
  sub_rooms  = { none=40, some=80, heaps=5 }
  islands    = { few=60, heaps=40 }
  teleporters ={ none=10, few=30, some=30, heaps=5 }  -- FIXME: none=50

  junk       = { few=10, some=60, heaps=20 }
  symmetry   = { few=20, some=60, heaps=20 }
  pillars    = { few=30, some=60, heaps=20 }
  beams      = { few=25, some=50, heaps=5  }
  barrels    = { few=50, some=50, heaps=10 }

  windows    = { few=20, some=50, heaps=200 }
  pictures   = { few=10, some=50, heaps=10 }
  cages      = { none=50, some=50, heaps=6 }
  crates     = { none=20, some=40, heaps=10 }

  lt_trim    = { none=40, some=20, heaps=10 }
  lt_spokes  = { none=90, some=20, heaps=5 }
  lt_swapped = { none=90, heaps=20 }

  room_shape = { none=30, L=5, T=5, U=10, H=10 }
}


function Levels_clean_up()
  GAME   = {}
  THEME  = {}
  PARAM  = {}
  STYLE  = {}

  LEVEL    = nil
  SEEDS    = nil
  SECTIONS = nil

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
  if name == "LEVEL_THEMES" or name == "ROOM_THEMES" or name == "AREA_THEMES" then
    Levels_merge_themes(GAME[name], tab)
    return
  end

  table.merge_w_copy(GAME[name], tab)
end


function Levels_merge_table_list(tab_list)
  each GT in tab_list do
    assert(GT)
    each name,tab in GT do
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


function Levels_collect_modules()
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


function Levels_invoke_hook(name, rseed, ...)
  -- two passes, for example: setup and setup2
  for pass = 1,2 do
    each mod in GAME.modules do
      local func = mod.hooks and mod.hooks[name]
      if func then
        if rseed then gui.rand_seed(rseed) end
        func(mod, ...)
      end
    end
    name = name .. "2"
  end
end


function Levels_setup()
  Levels_clean_up()

  Levels_collect_modules()

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

  Levels_invoke_hook("setup", OB_CONFIG.seed)

  if PARAM.sub_format then
    gui.property("sub_format", PARAM.sub_format)
  end

  table.name_up(PREFAB)
end


function Levels_choose_themes()
  gui.rand_seed(OB_CONFIG.seed * 200)

  local function set_level_theme(L, name)
    local info = assert(OB_THEMES[name])

    L.super_theme = info

    if not L.name_theme then
      L.name_theme = info.name_theme
    end

    -- don't overwrite theme of special levels
    if L.theme then return end

    local sub_tab = {}
    local sub_pattern = "^" .. name

    for which,theme in pairs(GAME.LEVEL_THEMES) do
      local prob = theme.prob or 50
      if prob > 0 and string.find(which, sub_pattern) then
        sub_tab[which] = prob
      end
    end

    if table.empty(sub_tab) then
      error("No sub-themes for " .. name)
    end

    L.theme_name = rand.key_by_probs(sub_tab)
    L.theme = assert(GAME.LEVEL_THEMES[L.theme_name])

    gui.printf("Theme for level %s = %s\n", L.name, L.theme_name)
  end


  ---| Levels_choose_themes |---

  gui.printf("\n")

  -- the user can specify the main theme
  if OB_CONFIG.theme != "mixed" and OB_CONFIG.theme != "original" and
     OB_CONFIG.theme != "psycho"
  then
    each L in GAME.levels do
      set_level_theme(L, OB_CONFIG.theme)
    end

    return;
  end

  if OB_CONFIG.theme == "psycho" then
    local prob_tab = {}
    for name,info in pairs(OB_THEMES) do
      local prob = info.psycho_prob or info.mixed_prob or 0
      if info.shown and prob then
        prob_tab[name] = prob
      end
    end

    assert(not table.empty(prob_tab))

    each L in GAME.levels do
      if not L.theme then
        local name = rand.key_by_probs(prob_tab)

        if not L.name_theme and ((_index % 2) == 1) then
          L.name_theme = "PSYCHO"
        end

        set_level_theme(L, name)
      end
    end

    return;
  end

  -- Mix It Up : choose a theme for each episode
  local episode_list = {}
  local total = 0

  local prob_tab = {}
  for name,info in pairs(OB_THEMES) do
    if info.shown and info.mixed_prob then
      prob_tab[name] = info.mixed_prob
      total = total + 1
    end
  end

  assert(total > 0)

  if OB_CONFIG.theme == "original" and GAME.original_themes then
    total = math.max(total, # GAME.original_themes)
  end

  while not table.empty(prob_tab) do
    local name = rand.key_by_probs(prob_tab)
    prob_tab[name] = nil

    local info = OB_THEMES[name]
    local pos = rand.irange(1, total)

    if OB_CONFIG.theme == "original" and GAME.original_themes then
      for i,orig_theme in ipairs(GAME.original_themes) do
        if name == orig_theme and not episode_list[i] then
          -- this can leave gaps, but they are filled later
          pos = i ; break
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
  if OB_CONFIG.theme == "original" and GAME.original_themes then
    gui.debugf("original_themes =\n%s\n", table.tostr(GAME.original_themes))

    for i,orig_theme in ipairs(GAME.original_themes) do
      if not episode_list[i] then
        episode_list[i] = orig_theme
      end
    end

    assert(# episode_list == total)
  end

  gui.printf("Theme for episodes =\n%s\n", table.tostr(episode_list))

  -- flesh it out
  if total == 2 then
    local dist = rand.sel(70, 0, 1)
    table.insert(episode_list, episode_list[1 + dist])
    table.insert(episode_list, episode_list[2 - dist])
  end

  while #episode_list < 90 do
    table.insert(episode_list, episode_list[rand.irange(1, total)])
  end


  -- single episode is different: have a few small batches
  if OB_CONFIG.length == "episode" then
    local pos = 1
    local count = 0

    each L in GAME.levels do
      if count >= 2 and (rand.odds(50) or count >= 5) then
        pos = pos + 1
        count = 0
      end

      set_level_theme(L, episode_list[pos])
      count = count + 1
    end

    return;
  end

  each L in GAME.levels do
    set_level_theme(L, episode_list[L.episode])
  end
end


function Levels_rarify(seed_idx, tab)
  gui.rand_seed(OB_CONFIG.seed * 200 + seed_idx)

  local function Rarify(name, rarity)
    for group = 1, #GAME.levels, rarity do
      
      -- this level in the group will allow the item, every other
      -- level will forbid it (by setting the allowance to 0).
      local which = rand.irange(0, rarity-1)

      for offset = 0, rarity-1 do
        local L = GAME.levels[group + offset]
        if not L then break; end

        L.allowances[name] = (offset == which ? 1, 0)

        -- spice it up a bit more
        if rand.odds(10) then
          L.allowances[name] = 1 - L.allowances[name]
        end
      end -- for offset
    end -- for group
  end

  --| Levels_rarify |--

  each L in GAME.levels do
    if not L.allowances then
      L.allowances = {}
    end
  end

  for name,info in pairs(tab) do
    if info.rarity and info.rarity > 1 then
      Rarify(name, int(info.rarity))
    end
  end

  each L in GAME.levels do
    if not table.empty(L.allowances) then
      gui.debugf("Allowances in level %s =\n", L.name)
      gui.debugf("%s\n", table.tostr(L.allowances, 1))
    end
  end
end


function Levels_do_styles()
  gui.rand_seed(LEVEL.seed)

  local style_tab = table.copy(GLOBAL_STYLE_LIST)

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
  if OB_CONFIG.outdoors and OB_CONFIG.outdoors != "mixed" then
    STYLE.skies = OB_CONFIG.outdoors
  end

  SKY_H = rand.sel(5, 768, 512)

  if OB_CONFIG.theme == "psycho" then
    Mat_prepare_trip()
  end
end


function Levels_build_it()
  gui.rand_seed(LEVEL.seed)

  -- does the level have a custom build function?
  if LEVEL.build_func then
    LEVEL.build_func(LEVEL.build_data)
    if gui.abort() then return "abort" end
    return "ok"
  end

--[[
  Quake_test() ; do return "ok" end
--]]

  Plan_create_rooms()
  if gui.abort() then return "abort" end

  Connect_rooms()
  if gui.abort() then return "abort" end

  Quest_make_quests()
  if gui.abort() then return "abort" end

  gui.prog_step("Rooms");

  Rooms_build_all()
  if gui.abort() then return "abort" end

  gui.prog_step("Mons");

  Monsters_make_battles()
  if gui.abort() then return "abort" end

  return "ok"
end


function Levels_handle_prebuilt()
  -- randomly pick one
  local probs = {}

  for idx,info in ipairs(LEVEL.prebuilt) do
    probs[idx] = info.prob or 50
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


function Levels_make_level(L, index, NUM)
  LEVEL = L

  assert(LEVEL)
  assert(LEVEL.name)

  gui.at_level(LEVEL.name, index, NUM)

  gui.printf("\n\n~~~~~~| %s |~~~~~~\n", LEVEL.name)


  LEVEL.seed = OB_CONFIG.seed * 100 + index
  LEVEL.ids  = {}

  THEME = table.copy(assert(LEVEL.theme))

  if GAME.THEME_DEFAULTS then
    table.merge_missing(THEME, GAME.THEME_DEFAULTS)
  end


  -- use a pre-built level ?

  if LEVEL.prebuilt then
    Levels_invoke_hook("begin_level",  LEVEL.seed)

    local res = Levels_handle_prebuilt()
    if res == "abort" then
      return res
    end

    Levels_invoke_hook("end_level",  LEVEL.seed)
    return "ok"
  end


  gui.begin_level()
  gui.property("level_name", LEVEL.name);

  Levels_do_styles()

  Levels_invoke_hook("begin_level",  LEVEL.seed)

  gui.printf("\nStyles = \n%s\n\n", table.tostr(STYLE, 1))


  local error_mat = assert(GAME.MATERIALS["_ERROR"])

  gui.property("error_tex",  error_mat.t)
  gui.property("error_flat", error_mat.f or error_mat.t)

  if LEVEL.description then
    gui.property("description", LEVEL.description)
  end


  local res = Levels_build_it()
  if res == "abort" then
    return res
  end


  Levels_invoke_hook("end_level",  LEVEL.seed)

  gui.end_level()


  if index < NUM then
    Levels_between_clean()
  end

  return "ok"
end


function Levels_make_all()
  GAME.levels = {}

  Levels_invoke_hook("get_levels",  OB_CONFIG.seed)

  if #GAME.levels == 0 then
    error("Level list is empty!")
  end

  Levels_choose_themes()

  Levels_rarify(1, GAME.WEAPONS)
--Levels_rarify(2, GAME.MONSTERS)
--Levels_rarify(3, GAME.POWERUPS)

  each L in GAME.levels do
    if Levels_make_level(L, _index, #GAME.levels) == "abort" then
      return "abort"
    end
  end

  Levels_invoke_hook("all_done",  OB_CONFIG.seed)

  return "ok"
end

