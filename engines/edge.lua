----------------------------------------------------------------
--  Engine: EDGE (Enhanced Doom Gaming Engine)
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2008 Andrew Apted
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

function Edge_remap_music()
  
  -- FIXME: DOOM2 specific!!!
  local mus_list =
  {
    "RUNNIN", "STALKS", "COUNTD", "BETWEE", "DOOM",
    "THE_DA", "SHAWN", "DDTBLU", "IN_CIT", "DEAD",
  }

  local old_list = table.copy(mus_list)

  rand_shuffle(mus_list)

  local data =
  {
    "//\n",
    "// Playlist.ddf created by OBLIGE\n",
    "//\n\n",
    "<PLAYLISTS>\n\n"
  }

  for i = 1,10 do
    local track = string.format(
      "[%2d] MUSICINFO = MUS:LUMP:D_%s;\n", i, mus_list[i])
 
    table.insert(data, track)
  end

  gui.wad_add_text_lump("DDFPLAY", data);
end


function Edge_create_language()
  
  local data =
  {
    "//\n",
    "// Language.ldf created by OBLIGE\n",
    "//\n\n",
    "<LANGUAGES>\n\n",
    "[ENGLISH]\n"
  }

  for _,L in ipairs(GAME.all_levels) do
    if L.description then
      local id = string.format("%sDesc", L.name)
      local text = L.name .. ": " .. L.description;

      table.insert(data, string.format("%s = \"%s\";\n", id, text))
    end
  end

  -- TODO: use TNTLANG and PLUTLANG when necessary
  gui.wad_add_text_lump("DDFLANG", data);
end


----------------------------------------------------------------

function Edge_all_done()
  Edge_create_language();

  -- Edge_remap_music()
end


OB_ENGINES["edge"] =
{
  label = "EDGE 1.34",
  priority = 90,

  for_games = { doom1=1, doom2=1 },

  all_done_func = Edge_all_done,

  param =
  {
    boom_lines = true,
    boom_sectors = true,

    extra_floors = true,
    liquid_floors = true,
    thing_exfloor_flags = true,

    mirrors = true,
  },
}

