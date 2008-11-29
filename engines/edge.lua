----------------------------------------------------------------
--  Engine: EDGE (Enhanced Doom Gaming Engine)
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2008 Andrew Apted
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

function Edge_set_level_name()
  assert(LEVEL.description)
  
  local id = string.format("%sDesc", LEVEL.name)
  local text = LEVEL.name .. ": " .. LEVEL.description;

  gui.ddf_add_string(id, text)
end

function Edge_remap_music()
  
  -- FIXME: game specific!!!
  local mus_list =
  {
    "RUNNIN", "STALKS", "COUNTD", "BETWEE", "DOOM",
    "THE_DA", "SHAWN", "DDTBLU", "IN_CIT", "DEAD",
  }

  local old_list = copy_table(mus_list)

  rand_shuffle(mus_list)

  for i = 1,10 do
    local track = string.format("%02d", i)

    gui.ddf_add_music(track, "MUS:LUMP:D_" .. mus_list[i])
--  gui.bex_add_music(old_list[i], mus_list[i])
  end
end


OB_ENGINES["edge"] =
{
  label = "EDGE 1.31",
  priority = 90,

  for_games = { doom1=1, doom2=1, freedoom=1 },

  caps =
  {
    boom_lines = true,
    boom_sectors = true,

    extra_floors = true,
    liquid_floors = true,
    thing_exfloor_flags = true,

    mirrors = true,
  },

  hooks =
  {
    set_level_name = Edge_set_level_name,
    remap_music    = Edge_remap_music,
  },
}

