# OBSIDIAN
by the ObAddon Community.


## INTRODUCTION

OBSIDIAN is a random level generator for the classic FPS 'DOOM'.
The goal is to produce good levels which are fun to play.

Features of OBSIDIAN include:

* high quality levels, e.g. outdoor areas and caves!
* easy to use GUI interface (no messing with command lines)
* built-in node builder, so the levels are ready to play
* uses the LUA scripting language for easy customisation

## QUICK START GUIDE (Windows)

First, unpack the zip somewhere (e.g. My Documents).  Make sure it is extracted with folders, and also make sure the OBSIDIAN.EXE file gets extracted too.

Double click on the OBSIDIAN icon to run it.  Select the game in the top left panel, and any other options which take your fancy. Then click the BUILD button in the bottom left panel, and enter an output filename, for example "TEST" (without the quotes).

OBSIDIAN will then build all the maps, showing a blueprint of each one as it goes, and if everything goes smoothly the output file (e.g. "TEST.WAD") will be created at the end.  Then you can play it using the normal method for playing mods with that game (e.g. for DOOM source ports: dragging-n-dropping the WAD file onto the source port's EXE is usually enough).

## QUICK START GUIDE (Linux)

Please refer to COMPILING.md to build Obsidian for Linux

## About This Repository

This is a community continuation of the OBLIGE Level Maker, originally created by Andrew Apted.

A brief summary of changes:

Basic support added for HacX 1.2, Chex Quest 3, Harmony, and Hexen.

Hexen map format is supported; in addition there is a translation layer to convert
some Doom-formatted prefabs to Hexen format.

Experimental support added for Strife.

GUI Customization and Theming added

Modified SLUMP level builder included for Vanilla Doom usage.

ZDBSP as the internal nodebuilder, replacing GLBSP.

UDMF map generation option for GZDoom and Eternity Engine.

64-bit seeds and random numbers.

Migrated from Lua to LuaJIT. Lua scripts from previous versions of Oblige/ObAddon will be incompatible without conversion.

Patch by Simon-v for searching for .pk3 addons in both the install and user's home directories (https://github.com/dashodanger/Oblige/pull/1)

Strings allowed for seed input (numbers with no other characters still processed as numbers).

New random number generator based on the xoshiro256 algorithm from fastPRNG (https://github.com/BrutPitt/fastPRNG).

Bugfixes as discovered.
