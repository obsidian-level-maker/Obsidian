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

require 'util'


OB_ENGINES =
{
  nolimit =
  {
    name = "Limit Removing",
    priority = 100,
  },

  boom =
  {
    name = "BOOM Compat",
    priority = 90,
    for_games = { "doom1", "doom2", "freedoom" },
  },

  edge =
  {
    name = "EDGE",
    priority = 80,
    for_games = { "doom1", "doom2", "freedoom" },
  },

  doomsday =
  {
    name = "Doomsday",
    for_games = { "doom1", "doom2", "freedoom", "heretic", "hexen" },
  },

  legacy =
  {
    name = "Legacy",
    for_games = { "doom1", "doom2", "freedoom" },
  },

  skulltag =
  {
    name = "Skulltag",
    for_games = { "doom1", "doom2", "freedoom", "heretic", "hexen" },
  },

  vavoom =
  {
    name = "Vavoom",
    for_games = { "doom1", "doom2", "freedoom", "heretic", "hexen", "strife" },
  },

  zdoom =
  {
    name = "ZDoom",
    for_games = { "doom1", "doom2", "freedoom", "heretic", "hexen" },
  },

}

