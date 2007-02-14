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

require 'theme'
require 'planner'
require 'plan_dm'

require 'monster'
require 'builder'
require 'writer'


function get_level_names(settings)

  local LEVELS = {}

  if (settings.game == "doom1") or (settings.game == "heretic") then

    local epi_num = sel(settings.length == "full",   3, 1)
    local lev_num = sel(settings.length == "single", 1, 9)

    for e = 1,epi_num do
      for m = 1,lev_num do
        table.insert(LEVELS, string.format("E%dM%d", e, m))
      end
    end

  else  -- doom2 / freedoom / hexen

    local TS = { single=1, episode=10, full=32 }
    local total = TS[settings.length]
    assert(total)

    for i = 1,total do
      table.insert(LEVELS, string.format("MAP%02d", i))
    end
  end

  return LEVELS
end


function create_theme()

  local factory = THEME_FACTORIES[settings.game]

  if not factory then
    error("UNKNOWN GAME '" .. settings.game .. "'")
  end

  THEME = factory()

  compute_pow_factors()
end


function build_cool_shit()
 
  assert(settings)

  -- the missing console functions
  con.printf = function (fmt, ...)
    if fmt then con.raw_log_print(string.format(fmt, ...)) end
  end

  con.debugf = function (fmt, ...)
    if fmt then con.raw_debug_print(string.format(fmt, ...)) end
  end

  con.printf("\n\n~~~~~~~ Making Levels ~~~~~~~\n\n")

  con.printf("SEED = %d\n\n", settings.seed)
  con.printf("Settings =\n%s\n", table_to_string(settings))

  create_theme()

  local aborted = false
  local LEVELS = get_level_names(settings)

  for idx,lev in ipairs(LEVELS) do

    con.at_level(lev, idx, #LEVELS)

    con.printf("\n=====| %s |=====\n\n", lev)

    con.rand_seed(settings.seed * 100 + idx)
 
    if settings.mode == "dm" then
      PLAN = plan_dm_arena()
    elseif settings.mode == "coop" then
      PLAN = plan_sp_level(true)
    else
      PLAN = plan_sp_level(false)
    end

    if con.abort() then aborted = true; break; end

    show_quests(PLAN)
    con.printf("\n")

    if settings.mode == "dm" then
      show_dm_links(PLAN)
    else
      show_path(PLAN)
    end
    con.printf("\n")

    build_level(PLAN)

    if con.abort() then aborted = true; break; end

    write_level(PLAN, lev)

    if con.abort() then aborted = true; break; end
  end

  if aborted then
    con.printf("\n~~~~~~~ Build Aborted! ~~~~~~~\n\n")
    return "abort"
  end

  con.printf("\n~~~~~~ Finished Making Levels ~~~~~~\n\n")

  return "ok"
end

