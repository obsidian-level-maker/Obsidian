----------------------------------------------------------------
--  Engine: BOOM Compatible
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

function Boom_create_dehacked()

  local data =
  {
    "#\n",
    "# BEX LUMP created by OBLIGE\n",
    "#\n\n",
  }

  -- Level names...
  local strings_marker = false;

  for _,L in ipairs(GAME.all_levels) do
    if L.description then
      local id

      if string.sub(L.name, 1, 1) == 'E' then
        -- Doom I : HUSTR_ExMy
        id = "HUSTR_" .. L.name

      else
        local pos = 4
        if string.sub(L.name, pos, pos) == '0' then
          pos = pos + 1
        end

        -- Doom II : HUSTR_%d
        id = "HUSTR_" .. string.sub(L.name, pos)
      end

      local text = L.name .. ": " .. L.description;

      if not strings_marker then
        table.insert(data, "[STRINGS]\n")
        strings_marker = true
      end

      table.insert(data, string.format("%s = %s\n", id, text))
    end
  end -- for L

  -- TODO: music replacement

  table.insert(data, "\n");

  gui.wad_add_text_lump("DEHACKED", data);
end


----------------------------------------------------------------

function Boom_all_done()
  Boom_create_dehacked();
end


OB_ENGINES["boom"] =
{
  label = "BOOM Compat",
  priority = 92,

  for_games = { doom1=1, doom2=1 },

  hooks =
  {
    all_done = Boom_all_done,
  },

  param =
  {
    boom_lines = true,
    boom_sectors = true,
  },
}

