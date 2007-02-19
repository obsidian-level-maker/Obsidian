
OBLIGE 0.85 Read-Me
===================

by Andrew Apted.   February 2007


INTRODUCTION

   OBLIGE is a random level maker for the following games:
   DOOM 1, DOOM 2, Final DOOM, FreeDOOM, Heretic 1 and Hexen 1.
   These games all share the same basic level structure.

   OBLIGE will have the following features which set it apart
   from existing programs (like the famous SLIGE by David
   Chess) :-

     * higher quality levels, e.g. outdoor areas!
     * easy to use GUI interface (no messing with command lines)
     * built-in node builder, so the levels are ready to play
     * uses the LUA scripting language for easy customisation
     * can create Deathmatch levels
     * Heretic and Hexen support!


STATUS

   OBLIGE 0.85 is the current version (the previous version was
   0.81, the very first public release). The core level-making
   algorithm exists and works well, and the GUI interface is
   simple but very usable. The battle simulator produces
   reasonable ammo and health to fight the monsters in the map.

   See below for the status of each game

   There is still a lot to do however. There is no support (yet)
   for the special levels, such as the end-of-episode levels of
   DOOM 1 and the end-of-game level (MAP30) of DOOM 2. Other nice
   features would be: secret areas, player teleports, and better
   lighting.

   Nearly every decision in OBLIGE, such as what monsters to make
   and what themes to use for rooms, is just roll-of-the-die
   random. There is so much potential for using much better
   algorithms (and hence creating much nicer levels). Send me an
   email if you are interested in helping out, you certainly
   don't need to be a programmer!


CHANGES IN 0.85

   +  Hallways!  Crates!  Exit themes!
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
   -  improved cages, now at more reasonable heights.
   -  neater placement for health and ammo items.


USAGE GUIDE

   The graphical interface for OBLIGE is quite easy to use.

   At the top is the Settings panel, which contains the most
   important settings.

   The first control is the "SEED" number. Each SEED number
   produces a unique, distinctive level. Using the same SEED
   number always produces the exact same level (as long as the
   other settings are the same).

   Other settings include:
     * the "Game" type (DOOM 1, DOOM 2, HERETIC or HEXEN),
     * the "Mode" of the game (SINGLE-PLAYER, CO-OP, or DEATHMATCH)
     * the "Length" of the output wad (SINGLE-LEVEL, ONE-EPISODE,
       or FULL-GAME).

   In the Adjustments panel you can control how much health and
   ammunition, and how many monsters and traps are put into the
   created levels. OBLIGE also implements the different skill
   levels for each map (e.g. Hurt-me-Plenty vs Ultra-Violence).

   After you've chosen the desired settings, press the "Build..."
   button, which will open a Save-File dialog asking you what the
   output file should be. Enter something appropriate, e.g. TEST,
   and after that OBLIGE will starting building the levels.

   To exit, press the "Quit" button in the bottom right corner.

   The levels created by OBLIGE are ready to play.  There is no
   need to run the output WAD file through a node-builder program,
   since OBLIGE does this automatically.

   You should use a Source Port to play the levels, because the
   original DOOM.EXE, DOOM2.EXE (etc..) may not cope with the
   architecture which OBLIGE creates.  For example, you might
   get the dreaded "Visplane Overflow" error, which is fatal.


STATUS OF EACH GAME

   DOOM 2: by far the most well tested and stable game target,
   and contains the most number of different themes.

   DOOM 1: has been tested and works pretty well.  Some extra
   themes would be nice to have (e.g. for hell levels that DOOM 1
   does so well).

   HERETIC: poorly tested and very lacking in different themes,
   and it's possible that some keyed doors might not work
   properly (requiring the wrong key) or other similar
   problems.

   HEXEN: basically borked, can create levels but they won't
   work properly, e.g. none of the linedefs have the correct
   line-types (for doors and lifts etc). Also very lacking in
   themes. Plus none of the HEXEN special features, such as the
   hub system, player classes, or the three-part weapons are
   supported yet.


COPYRIGHT and LICENSE

   OBLIGE Level Maker

   Copyright (C) 2006-2007 Andrew Apted

   OBLIGE is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation; either version
   2 of the License, or (at your option) any later version.

   OBLIGE is distributed in the hope that it will be useful, but
   WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
   [5]GNU General Public License for more details.


CONTACT DETAILS

   Email: <ajapted@users.sf.net>

   Website: http://oblige.sourceforge.net/

   Project page: http://sourceforge.net/projects/oblige/

   Hosted by: SourceForge.net 

