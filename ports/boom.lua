----------------------------------------------------------------
--  Engine: BOOM Compatible
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2008-2016  Andrew Apted
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

BOOM = {}


BOOM.ENTITIES =
{
  boom_player5 = { id=4001, r=16, h=56 },
  boom_player6 = { id=4002, r=16, h=56 },
  boom_player7 = { id=4003, r=16, h=56 },
  boom_player8 = { id=4004, r=16, h=56 },

  -- CTF things
  ctf_blue_flag  = { id=5130, r=16, h=56, pass=true },
  ctf_blue_start = { id=5080, r=16, h=56, pass=true },
  ctf_red_flag   = { id=5131, r=16, h=56, pass=true },
  ctf_red_start  = { id=5081, r=16, h=56, pass=true },

  point_push = { id=5001, r=16,h=16, pass=true },
  point_pull = { id=5002, r=16,h=16, pass=true }
}


BOOM.PARAMETERS =
{
  boom_lines = true,
  boom_sectors = true
}


function BOOM.create_dehacked()

  local data =
  {
    "#\n",
    "# BEX LUMP created by Obsidian\n",
    "#\n\n"
  }

  local strings_marker = false;

  local function add_string(id, text)
    if not strings_marker then
      table.insert(data, "[STRINGS]\n")
      strings_marker = true
    end

    -- escape any newlines in the text
    text = string.gsub(text, "\n", "\\n")

    table.insert(data, string.format("%s = %s\n", id, text))
  end



  --- level names ---

  for _,L in pairs(GAME.levels) do
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

      add_string(id, text)
    end
  end -- for L

  --- episode texts ---

  for _,EPI in pairs(GAME.episodes) do
    if EPI.mid_text and EPI.bex_mid_name then
      add_string(EPI.bex_mid_name, EPI.mid_text)
    end
    if EPI.end_text and EPI.bex_end_name then
      add_string(EPI.bex_end_name, EPI.end_text)
    end
  end

  if GAME.secret_text and PARAM.bex_secret_name then
    add_string(PARAM.bex_secret_name, GAME.secret_text)
  end
  if GAME.secret2_text and PARAM.bex_secret2_name then
    add_string(PARAM.bex_secret2_name, GAME.secret2_text)
  end

  table.insert(data, "\n");

  --- music replacement ---

  if GAME.music_mapping then
    table.insert(data, GAME.music_mapping)
    table.insert(data, "\n");
  end

  if ob_mod_enabled("compress_output") == 1 and OB_CONFIG.port ~= "dsda" then
    gui.wad_add_text_lump("DEHACKED.txt", data)
  else
    gui.wad_add_text_lump("DEHACKED", data)
  end
end



function BOOM.all_done()
  BOOM.create_dehacked()
end


----------------------------------------------------------------


OB_PORTS["boom"] =
{
  label = _("BOOM Compat"),

  priority = 102,  -- this makes it top-most, and the default engine

  game = { chex1=1, doom1=1, doom2=1, hacx=1 },

  tables =
  {
    BOOM
  },

  hooks =
  {
    all_done = BOOM.all_done
  }
}

----------------------------------------------------------------

-- This should not be visible in the Engine selection list; it's a shim to separate UDMF/advanced engines

ADVANCED = {}


ADVANCED.ENTITIES =
{

}


ADVANCED.PARAMETERS =
{

}


OB_PORTS["advanced"] =
{
  label = _("Advanced"),
  priority = 95,

  extends = "boom",

  tables =
  {
    ADVANCED
  },

  hooks =
  {

  }

}

----------------------------------------------------------------

DSDA = {}


DSDA.ENTITIES =
{

}


DSDA.PARAMETERS =
{

}

OB_PORTS["dsda"] =
{
  label = _("DSDA-Doom"),
  priority = 97,

  extends = "advanced",

  game = { chex1=1, doom1=1, doom2=1, hacx=1, heretic=1, hexen=1 },

  tables =
  {
    DSDA
  },

  hooks =
  {

  }

}