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
}


--*** Wolf3d ***--

OB_ENGINES["wolf4sdl"] =
{
  label = "Wolf4SDL",
  for_games = { wolf3d=1 },
}


--*** DOOM, Heretic and HeXeN ***--

OB_ENGINES["boom"] =
{
  label = "BOOM Compat",
  priority = 92,
  for_games = { doom1=1, doom2=1, freedoom=1 },
}

OB_ENGINES["edge"] =
{
  label = "EDGE",
  priority = 90,
  for_games = { doom1=1, doom2=1, freedoom=1 },
}

OB_ENGINES["doomsday"] =
{
  label = "Doomsday",
  for_games = { doom1=1, doom2=1, heretic=1, hexen=1 },
}

OB_ENGINES["legacy"] =
{
  label = "Legacy",
  for_games = { doom1=1, doom2=1, freedoom=1 },
}

--[[ deathmatch ports disabled until Oblige can make DM maps again
OB_ENGINES["skulltag"] =
{
  label = "Skulltag",
  for_games = { doom1=1, doom2=1, heretic=1, hexen=1 },
}
--]]

OB_ENGINES["vavoom"] =
{
  label = "Vavoom",
  for_games = { doom1=1, doom2=1, heretic=1, hexen=1, strife=1 },
}

OB_ENGINES["zdoom"] =
{
  label = "ZDoom",
  for_games = { doom1=1, doom2=1, freedoom=1, heretic=1, hexen=1 },
}


--*** Quake I ***--

OB_ENGINES["darky"] =
{
  label = "DarkPlaces",
  for_games = { quake1=1 },
}

OB_ENGINES["fitz"] =
{
  label = "FitzQuake",
  for_games = { quake1=1 },
}


--*** Quake II ***--

-- q2pro??

