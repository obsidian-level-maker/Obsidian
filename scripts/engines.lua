----------------------------------------------------------------
--  Engine (source port) list
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006,2007 Andrew Apted
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


OB_ENGINES["nolimit"] =
{
  label = "Limit Removing",
  priority = 95,
}

OB_ENGINES["boom"] =
{
  label = "BOOM Compat",
  priority = 92,
  for_games = { "doom1", "doom2" },
}

OB_ENGINES["edge"] =
{
  label = "EDGE",
  priority = 90,
  for_games = { "doom1", "doom2" },
}

OB_ENGINES["doomsday"] =
{
  label = "Doomsday",
  for_games = { "doom1", "doom2", "heretic", "hexen" },
}

OB_ENGINES["legacy"] =
{
  label = "Legacy",
  for_games = { "doom1", "doom2" },
}

OB_ENGINES["skulltag"] =
{
  label = "Skulltag",
  for_games = { "doom1", "doom2", "heretic", "hexen" },
}

OB_ENGINES["vavoom"] =
{
  label = "Vavoom",
  for_games = { "doom1", "doom2", "heretic", "hexen", "strife" },
}

OB_ENGINES["zdoom"] =
{
  label = "ZDoom",
  for_games = { "doom1", "doom2", "heretic", "hexen" },
}

