----------------------------------------------------------------
--  LEVEL MANAGEMENT
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006-2009 Andrew Apted
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

require 'arenas'
require 'layout'
require 'rooms'
require 'tiler'
require 'fight'
require 'monsters'


STYLE_LIST =
{
  skies      = { few=20, some=60, heaps=40 },
  hallways   = { few=10, some=90, heaps=30 },
  liquids    = { few=30, some=50, heaps=20 },
  scenics    = { few=30, some=50, heaps=10 },
  subrooms   = { none=40, some=80, heaps=5 },
  islands    = { few=60, heaps=40 },

  junk       = { few=10, some=60, heaps=20 },
  symmetry   = { few=20, some=60, heaps=20 },
  pillars    = { few=30, some=60, heaps=20 },
  beams      = { few=25, some=50, heaps=5  },
  barrels    = { few=50, some=50, heaps=10 },

  windows    = { few=20, some=50, heaps=20 },
  pictures   = { few=10, some=50, heaps=10 },
  cages      = { none=50, some=50, heaps=6 },
  fences     = { none=30, few=30, some=10 },
  crates     = { none=20, some=40, heaps=10 },

  lt_trim    = { none=40, some=20, heaps=10 },
  lt_spokes  = { none=90, some=20, heaps=5 },
  lt_swapped = { none=90, heaps=20 },

  favor_shape = { none=80, L=5, T=5, O=5, S=5, X=5 },

  dm_liquid = { nukage=50, lava=10 },  -- FIXME: game specific
}


function Game_merge_tab(name, t)
  if not t then
    error("Missing table for Game_merge_tab: " .. tostring(name))
  end

  if not GAME[name] then
    GAME[name] = {}
  end

  deep_merge(GAME[name], t)
end


function Game_clean_up()
  GAME   = {}
  PARAM  = {}
  STYLE  = {}

  LEVEL  = nil
  SEEDS  = nil

  collectgarbage("collect")
end


local function Game_sort_modules()
  GAME.all_modules = {}

  local game = OB_GAMES[OB_CONFIG.game]
  if not game then
    error("UNKNOWN GAME: " .. tostring(OB_CONFIG.game))
  end

  local engine = OB_ENGINES[OB_CONFIG.engine]
  if not engine then
    error("UNKNOWN ENGINE: " .. tostring(OB_CONFIG.engine))
  end

  -- find all the visible & enabled modules

  for _,mod in pairs(OB_MODULES) do
    if mod.enabled and mod.shown then
      table.insert(GAME.all_modules, mod)
    end
  end

  -- sort them : lowest -> highest priority, because later
  -- entries can override things done by earlier ones.

  local function module_sorter(A, B)
    if A.priority or B.priority then
      return (A.priority or 0) < (B.priority or 0)
    end

    return A.label < B.label
  end

  if #GAME.all_modules > 1 then
    table.sort(GAME.all_modules, module_sorter)
  end
 
  -- first entry must be the game def, and second entry must be
  -- the engine def.  NOTE: neither of these are real modules.

  table.insert(GAME.all_modules, 1, game)
  table.insert(GAME.all_modules, 2, engine)
end


function Game_invoke_hook(name, rseed, ...)
  for index,mod in ipairs(GAME.all_modules) do
    local func = mod[name]
    if func then
      if rseed then gui.rand_seed(rseed) end
      func(...)
    end
  end -- for mod
end


function Game_setup()

  Game_clean_up()

  Game_sort_modules()


  local game = GAME.all_modules[1]

  GAME.format = assert(game.format)


  local DEEP_TABLES = { themes=true, rooms=true }

  for index,mod in ipairs(GAME.all_modules) do
    if mod.param then
      shallow_merge(PARAM, mod.param)
    end

    if mod.tables then
      for i = 1,#mod.tables,2 do
        local name = mod.tables[i]
        local tab  = mod.tables[i+1]

        assert(name)
        if not tab then
          error("No such table: " .. tostring(name))
        end

        if not GAME[name] then
          GAME[name] = deep_copy(tab)
        elseif DEEP_TABLES[name] then
          deep_merge(GAME[name], tab)
        else
          deepish_merge(GAME[name], tab)
        end
      end
    end
  end -- for mod

  Game_invoke_hook("setup_func",  OB_CONFIG.seed)
  Game_invoke_hook("setup2_func", OB_CONFIG.seed)


  -- miscellanous stuff
  if PARAM.pack_sidedefs then
    gui.property("pack_sidedefs", "1")
  end

  name_it_up(ROOM_PATTERNS)
  expand_copies(ROOM_PATTERNS)
end


function Level_styles()
  for name,prob_tab in pairs(STYLE_LIST) do
    STYLE[name] = rand_key_by_probs(prob_tab)
  end

  -- GUI overrides...
  if OB_CONFIG.outdoors and OB_CONFIG.outdoors ~= "mixed" then
    STYLE.skies = OB_CONFIG.outdoors
  end

  -- per level overrides...
  if LEVEL.style then
    for name,value in pairs(LEVEL.style) do
      STYLE[name] = value
    end
  end
  
  gui.printf("\nStyles = \n%s\n\n", table_to_str(STYLE, 1))
end


function Level_build_it()

  -- does the level have a custom build function (e.g. Arenas) ?
  if LEVEL.build_func then
    LEVEL.build_func()
    if gui.abort() then return "abort" end

    gui.progress(90)
    return "ok"
  end

  Plan_rooms_sp()
    if gui.abort() then return "abort" end
    gui.progress(10)

  Connect_rooms()
    if gui.abort() then return "abort" end
    gui.progress(30)

  Quest_assign()
    if gui.abort() then return "abort" end
    gui.progress(50)

  Rooms_build_all()
    if gui.abort() then return "abort" end
    gui.progress(70)

  if PARAM.tiled then
    Tiler_layout_all()
    return "ok" --!!!! FIXME
  end

  Monsters_make_battles()
    if gui.abort() then return "abort" end
    gui.progress(90)

  return "ok"
end


function Level_make(L, index, NUM)
  LEVEL = L

  assert(LEVEL)
  assert(LEVEL.name)

  gui.printf("\n\n~~~~~~| %s |~~~~~~\n", LEVEL.name)

  gui.at_level(LEVEL.name, index, NUM)

  LEVEL.theme = GAME.themes["TECH"] -- FIXME

  LEVEL.seed = OB_CONFIG.seed * 100 + index


  gui.begin_level()
  gui.property("level_name", LEVEL.name);

  Game_invoke_hook("begin_level_func",  LEVEL.seed)
  Game_invoke_hook("begin_level2_func", LEVEL.seed)

  if PARAM.error_tex then
    gui.property("error_tex",  PARAM.error_tex)
    gui.property("error_flat", PARAM.error_flat or PARAM.error_tex)
  end   

  if LEVEL.description then
---!!!    if HOOKS.set_level_desc then
---!!!       HOOKS.set_level_desc(LEVEL.description)
---!!!    else
      gui.property("description", LEVEL.description)
---!!!    end
  end


  gui.rand_seed(LEVEL.seed)

  Level_styles()

  gui.rand_seed(LEVEL.seed)

  local res = Level_build_it()
  if res == "abort" then
    return res
  end


  Game_invoke_hook("end_level_func",  LEVEL.seed)
  Game_invoke_hook("end_level2_func", LEVEL.seed)

  gui.end_level()


---!!!  -- FIXME: invoke "level_finish" signal
---!!!  if HOOKS.make_level_gfx and LEVEL.description then
---!!!     HOOKS.make_level_gfx(LEVEL.description)
---!!!  end

  -- intra-level cleanup
  if index < NUM then
    LEVEL = nil
    SEEDS = nil

    collectgarbage("collect")
  end

  return "ok"
end


function Game_make_all()

  GAME.all_levels = {}

  Game_invoke_hook("levels_start_func",  OB_CONFIG.seed)
  Game_invoke_hook("levels_start2_func", OB_CONFIG.seed)

  if #GAME.all_levels == 0 then
    error("Level list is empty!")
  end

  for index,L in ipairs(GAME.all_levels) do
    if Level_make(L, index, #GAME.all_levels) == "abort" then
      return "abort"
    end
  end

  Game_invoke_hook("all_done_func",  OB_CONFIG.seed)
  Game_invoke_hook("all_done2_func", OB_CONFIG.seed)

---!!!  if HOOKS.remap_music then
---!!!     HOOKS.remap_music()
---!!!  end

  return "ok"
end

