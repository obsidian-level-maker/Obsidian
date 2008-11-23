----------------------------------------------------------------
--  Engine (source port) list
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


function Boom_set_level_name()
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

function Edge_set_level_name()
  assert(LEVEL.description)
  
  local id = string.format("%sDesc", LEVEL.name)
  local text = LEVEL.name .. ": " .. LEVEL.description;

  gui.ddf_add_string(id, text)
end


--============================================================--


--*** Catch-all ***--

OB_ENGINES["nolimit"] =
{
  label = "Limit Removing",
  priority = 95,

  -- 'caps' is purely what the game definition provides
}


--*** Wolf3d ***--


--*** DOOM, Heretic and HeXeN ***--

OB_ENGINES["boom"] =
{
  label = "BOOM Compat",
  priority = 92,

  for_games = { doom1=1, doom2=1, freedoom=1 },

  caps =
  {
    boom_lines = true,
    boom_sectors = true,
  },

  hooks =
  {
    set_level_name = Boom_set_level_name,
  },
}

OB_ENGINES["edge"] =
{
  label = "EDGE",
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
  },
}

OB_ENGINES["doomsday"] =
{
  label = "Doomsday",

  for_games = { doom1=1, doom2=1, heretic=1, hexen=1 },

  caps =
  {
    -- TODO
  },
}

OB_ENGINES["eternity"] =
{
  label = "Eternity",

  for_games = { doom1=1, doom2=1, heretic=1, hexen=1 },

  caps =
  {
    -- TODO
  },

  hooks =
  {
    set_level_name = Boom_set_level_name,
  },
}

OB_ENGINES["legacy"] =
{
  label = "Legacy",

  for_games = { doom1=1, doom2=1, freedoom=1 },

  caps =
  {
    boom_lines = true,
    boom_sectors = true,

    extra_floors = true,
    liquid_floors = true,
  },

  hooks =
  {
    set_level_name = Boom_set_level_name,
  },
}

OB_ENGINES["vavoom"] =
{
  label = "Vavoom",

  for_games = { doom1=1, doom2=1, heretic=1, hexen=1, strife=1 },

  caps =
  {
    -- TODO
  },
}

OB_ENGINES["zdoom"] =
{
  label = "ZDoom",

  for_games = { doom1=1, doom2=1, freedoom=1, heretic=1, hexen=1 },

  caps =
  {
    -- TODO
  },
}


--*** Quake I ***--

OB_ENGINES["darky"] =
{
  label = "DarkPlaces",

  for_games = { quake1=1 },

  caps =
  {
    -- TODO
  },
}

OB_ENGINES["fitz"] =
{
  label = "FitzQuake",

  for_games = { quake1=1 },

  caps =
  {
    colored_lighting = true,
    global_fog = true,
    sky_box = true,
  },
}


--*** Hexen II ***--


--*** Quake II ***--


