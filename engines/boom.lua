----------------------------------------------------------------
--  Engine: BOOM Compatible
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

function Boom_set_level_desc()
  assert(LEVEL.description)
  
  local id

  if string.sub(LEVEL.name, 1, 1) == 'E' then

    -- Doom I : HUSTR_ExMy
    id = "HUSTR_" .. LEVEL.name

  else
    local pos = 4
    if string.sub(LEVEL.name, pos, pos) == '0' then
      pos = pos + 1
    end

    -- Doom II : HUSTR_%d
    id = "HUSTR_" .. string.sub(LEVEL.name, pos)
  end

  local text = LEVEL.name .. ": " .. LEVEL.description;

  gui.bex_add_string(id, text)
end


----------------------------------------------------------------


OB_ENGINES["boom"] =
{
  label = "BOOM Compat",
  priority = 92,

  for_games = { doom1=1, doom2=1, freedoom=1 },

  param =
  {
    boom_lines = true,
    boom_sectors = true,
  },

  hooks =
  {
    set_level_desc = Boom_set_level_desc,
  },
}

