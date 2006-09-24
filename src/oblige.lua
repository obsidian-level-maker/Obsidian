----------------------------------------------------------------
-- ObligeNG
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006 Andrew Apted
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

require 'planner'
require 'plan_dm'
require 'builder'
require 'writer'

function get_level_names(settings)

  local LEVELS = {}

  if (settings.game == "doom1") or (settings.game == "heretic") then

    local epi_num = sel(settings.size == "full", 3, 1)
    local lev_num = sel(settings.size == "one",  1, 9)

    for e = 1,epi_num do
      for m = 1,lev_num do
        table.insert(LEVELS, string.format("E%dM%d", e, m))
      end
    end

  else  -- doom2 / hexen

    local TS = { one=1, episode=10, full=32 }
    local total = TS[settings.size]
    assert(total)

    for i = 1,total do
      table.insert(LEVELS, string.format("MAP%02d", i))
    end
  end

  return LEVELS
end


function build_cool_shit()

  assert(settings)
--dump_table(settings, "settings"); do return end

  -- FIXME: custom random generators
  math.randomseed(settings.seed)

--!!  con.printf("\nSEED = %d\n\n", settings.seed)
io.stderr:write("\nSEED = ", settings.seed, "\n\n")

  local LEVELS = get_level_names(settings)

  for idx,lev in ipairs(LEVELS) do

    con.at_level(lev, idx, #LEVELS)
 
    local PLAN

    if settings.mode == "dm" then
      PLAN = plan_dm_arena()
    else
      PLAN = plan_sp_level()
    end

    if con.abort() then return "abort" end

do
  con.printf("=======  %s  ==============================\n", lev)
  show_quests(PLAN)
  if settings.mode == "dm" then
    show_dm_links(PLAN)
  else
    show_path(PLAN)
  end
end

    build_level(PLAN)

    if con.abort() then return "abort" end

    write_level(PLAN, lev)

    if con.abort() then return "abort" end
  end

  return "ok"
end

