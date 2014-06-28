----------------------------------------------------------------
--  Engine: BOOM Compatible
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2008,2010 Andrew Apted
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

BOOM = { }

BOOM.ENTITIES =
{
  point_push = { id=5001, kind="scenery", r=16,h=16, pass=true }
  point_pull = { id=5002, kind="scenery", r=16,h=16, pass=true }
}

BOOM.PARAMETERS =
{
  boom_lines = true
  boom_sectors = true
}


function BOOM.create_dehacked()
  
  local data =
  {
    "#\n"
    "# BEX LUMP created by OBLIGE\n"
    "#\n\n"
  }

  --- level names ---

  local strings_marker = false;

  each L in GAME.levels do
    local prefix = PARAM.bex_map_prefix

    if L.description and prefix then
      local id

      if string.sub(L.name, 1, 1) == 'E' then
        -- Doom I : HUSTR_ExMy
        id = prefix .. L.name

      else
        local pos = 4
        if string.sub(L.name, pos, pos) == '0' then
          pos = pos + 1
        end

        -- Doom II / Final Doom : HUSTR_%d
        id = prefix .. string.sub(L.name, pos)
      end

      local text = L.name .. ": " .. L.description;

      if not strings_marker then
        table.insert(data, "[STRINGS]\n")
        strings_marker = true
      end

      table.insert(data, string.format("%s = %s\n", id, text))
    end
  end -- for L

  table.insert(data, "\n");


  --- music replacement ---

  if GAME.music_mapping then
    table.insert(data, GAME.music_mapping)
    table.insert(data, "\n");
  end

  gui.wad_add_text_lump("DEHACKED", data);
end


----------------------------------------------------------------

function BOOM.all_done()
  BOOM.create_dehacked()
end


OB_ENGINES["boom"] =
{
  label = "BOOM Compat"
  priority = 92

  game = { doom1=1, doom2=1 }

  tables =
  {
    BOOM
  }

  hooks =
  {
    all_done = BOOM.all_done
  }
}

