----------------------------------------------------------------
--  Engine (source port) list
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006-2008 Andrew Apted
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


