
OBLIGE 0.81 Read-Me
===================

by Andrew Apted.   January 2007


INTRODUCTION

   OBLIGE is a random level maker for the following games: DOOM 1,
   DOOM 2, Heretic 1 and Hexen 1. These games all share the
   same basic level structure.

   OBLIGE will have the following features which set it apart
   from existing programs (like SLIGE by David Chess)

     * higher quality levels, e.g. outdoor areas!
     * easy to use GUI interface (no messing with command lines)
     * built-in node builder, so the created levels are ready to play
     * uses the LUA scripting language for easy experimentation
     * can create Deathmatch levels
     * Heretic and Hexen support!


STATUS

   OBLIGE 0.81 was the very first public release. The core
   level-making algorithm exists and works quite well, and the
   GUI is mostly usable (still missing some bells and whistles).
   The battle simulator seems to produce reasonable ammo/health
   for the monsters in the map.

   There is no support yet for the special levels, such as E1M8
   (end of episode) of DOOM 1 and MAP30 (end of game) of DOOM 2.

   Nearly every decision in OBLIGE, such as what monsters to
   make and what themes to use for rooms, is just roll-of-the-die
   random. There is still so much potential for using much better
   algorithms (and hence creating much nicer levels). Send me an
   email if you are interested in helping out, you certainly
   don't need to be a programmer!


USAGE GUIDE

   The graphical interface that OBLIGE is quite easy to use.
   The first control is the "SEED" number. Each SEED number
   produces a unique, distinctive level. Using the same SEED
   number always produces the exact same level (as long as the
   other settings are the same).

   Other settings include:
     * the "Game" type (DOOM 1, DOOM 2, HERETIC or HEXEN),
     * the "Mode" of the game (SINGLE-PLAYER, CO-OP, or DEATHMATCH)
     * the "Length" of the output wad (SINGLE-LEVEL, ONE-EPISODE,
       or FULL-GAME).

   After you've chosen the desired settings, press the "Build..."
   button, which will open a Save-File dialog asking you what the
   output file should be. Enter something appropriate, e.g. TEST,
   and after that OBLIGE will starting building the levels.

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

   DOOM 1: has been tested and works pretty well, although it's
   possible that a invalid texture might be used by mistake.
   Some extra themes would be nice to have (e.g. for hell
   levels that DOOM 1 does so well).

   HERETIC: poorly tested and very lacking in different themes,
   and it's possible that some keyed doors might not work
   properly (requiring the wrong key) or other similar
   problems.

   HEXEN: basically borked, can create levels but they won't
   work properly, e.g. none of the linedefs have the correct
   line-types (for doors and lifts etc). Also very lacking in
   themes. Plus none of the HEXEN specialities, such as the hub
   system, player classes, and three-part weapons, are supported
   yet.


COPYRIGHT and LICENSE

   OBLIGE Level Maker   Copyright (C) 2006-2007 Andrew Apted

   OBLIGE is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation; either version
   2 of the License, or (at your option) any later version.

   OBLIGE is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty
   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
   the GNU General Public License for more details.


CONTACT DETAILS

   Email: <ajapted@users.sf.net>

   Website: http://oblige.sourceforge.net/

   Project page: http://sourceforge.net/projects/oblige/

   Hosted by: SourceForge.net 

