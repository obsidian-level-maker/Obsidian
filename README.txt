
OBLIGE 0.94 Read-Me
===================

by Andrew Apted.   July 2007


INTRODUCTION

  OBLIGE is a random level maker for the following games: DOOM 1,
  DOOM 2, Final DOOM, FreeDOOM, Wolfenstein-3D, Heretic 1 and
  Hexen 1. These games all share the same basic level structure
  (except for Wolf3d which is much more limited).

  OBLIGE will have the following features which set it apart from
  existing programs (like the famous SLIGE by David Chess) :-

    * higher quality levels, e.g. outdoor areas!
    * easy to use GUI interface (no messing with command lines)
    * built-in node builder, so the levels are ready to play
    * uses the LUA scripting language for easy customisation
    * can create Deathmatch levels
    * Heretic and Hexen support!


STATUS

  OBLIGE 0.94 is the current version.  The GUI interface
  is simple but very usable. The battle simulator produces
  reasonable ammo and health to fight the monsters in the map.

  NOTE WELL: The 0.94 release does have some problems.  I am
  releasing it so that I can begin rewriting the level-building
  code to fix these problems (and also to generate better
  architecture).  For example, you might get an error message
  saying that some stairs or a switch could not be added into a
  room.  The only workaround is to try a different SEED value.

  (See below for the status of each game...)

  There is still a lot to do however. There is no support (yet)
  for the special levels, such as the end-of-episode levels of
  DOOM 1 and the end-of-game level (MAP30) of DOOM 2. Other
  desirable features are: nicer (non-square) architecture,
  player teleporters, and better lighting.


CHANGES IN 0.94

  +  new prefab system.
  +  new theme system for more consistent levels.
  +  different sized rooms.
  +  greatly improved Hexen support.

  -  new adjustments for level size and puzzles.
  -  adjustments for deathmatch games.
  -  secret areas and levels.
  -  balconies.

  -  experimental Wolfenstein-3D support.
  -  later levels get progressively harder.
  -  slightly better Heretic maps.
  -  more DOOM themes.

Note: some things also broke in this release, e.g. traps :-(


CHANGES IN 0.85

  +  Hallways!  Crates!  New Exits!
  +  better algorithm for choosing floor/ceiling heights.
  +  user adjustments for health/ammo/monsters/traps.
  +  current settings are remembered when you quit.

  -  support for FreeDOOM, TNT Evilution and Plutonia.
  -  levels are watermarked with some Oblige logos.
  -  delete temporary wad when build has finished.
  -  collect all log messages into a file (LOGS.txt).
  -  removed the unnecessary menu bar.

  -  fixed the (rare) non-working switches and lifts.
  -  surprise traps: improved placement, fairer monsters.
  -  tweaked battle simulation to provide more ammo.
  -  neater placement for health and ammo items.


USAGE GUIDE

  The graphical interface for OBLIGE is quite easy to use.

  At the top is the Settings panel, which contains the most
  important settings.

  The first control is the "SEED" number. Each SEED number makes
  a unique, distinctive level. Using the same SEED number always
  produces the exact same level (as long as the other settings
  are the same).

  Other settings include:

    * the "Game" type (DOOM, WOLF3D, HERETIC or HEXEN),
    * the "Mode" of the game (SINGLE-PLAYER, CO-OP, or DEATHMATCH)
    * the "Length" of the output wad (SINGLE-LEVEL, ONE-EPISODE,
      or FULL-GAME).

  In the Adjustments panel you can control the size of the created
  levels, as well as how much health, ammunition and how many
  monsters and puzzles are added. OBLIGE also implements the various
  skill levels for each map (e.g. Hurt-me-Plenty vs Ultra-Violence).

  After you've chosen the desired settings, press the "Build..."
  button, which will open a Save-File dialog asking you what the
  output file should be. Enter something appropriate, e.g. TEST,
  and after that OBLIGE will starting building the levels.

  In Wolfenstein-3D mode, the "Build..." button does not bring up
  a dialog box. OBLIGE simply creates the output files in the same
  folder where it is installed. These files are called GAMEMAPS.WL6
  and MAPHEAD.WL6 and you need to copy them into your Wolf3d folder
  (after making a backup!).

  To exit, press the "Quit" button in the bottom right corner.

  The levels created by OBLIGE are ready to play. There is no need
  to run the output WAD file through a node-builder program, since
  OBLIGE does this automatically.

  You should use a Source Port to play the levels, because the
  original DOOM.EXE, DOOM2.EXE (etc..) may not cope with the
  architecture which OBLIGE creates. For example, you might get
  the "Visplane Overflow" error, which quits the game.


STATUS OF EACH GAME

  DOOM 1: fairly well tested and working well.

  DOOM 2: the most well tested game and produces the best results.

  HERETIC: tested and working quite well, though very lacking in
  different themes and scenery.

  HEXEN: tested and works pretty well (greatly improved since
  the last v0.85 release). The sequence of hubs is not working
  properly yet.

  WOLF 3D: very buggy and incomplete at the moment.  It lacks:
  pushwall secrets, patrolling enemies, treasure rooms, proper
  episode endings, and may create levels with too many actors
  or static objects.


ACKNOWLEDGEMENTS

  Thanks to Derek "Dittohead" Braun for making a whole swag of
  Prefab structures, which kicked off some big improvements to
  the way OBLIGE builds stuff.

  Thanks to JohnnyRancid who also created heaps of prefabs for
  OBLIGE.

  Thanks to DoomJedi for his help.

  I'm grateful to everyone who provided positive feedback, bug
  reports and ideas for improvements, both in email and on the
  various forums. Cheers guys!

  OBLIGE uses the cool FLTK widget library (http://www.fltk.org).


COPYRIGHT and LICENSE

  OBLIGE Level Maker

  Copyright (C) 2006-2007 Andrew Apted

  OBLIGE is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published
  by the Free Software Foundation; either version 2 of the License,
  or (at your option) any later version.

  OBLIGE is distributed in the hope that it will be useful, but
  WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  GNU General Public License for more details.


CONTACT DETAILS

  Email: <ajapted@users.sf.net>

  Website: http://oblige.sourceforge.net/

  Project page: http://sourceforge.net/projects/oblige/

