# IF YOU JUST WANT THE PROGRAM
https://github.com/obsidian-level-maker/Obsidian/releases

# DISCORD SERVER FOR QUESTIONS, ADDONS, HELP, ETC
https://discord.gg/dfqCt9v

# OBSIDIAN
by the ObAddon Community.

## INTRODUCTION

OBSIDIAN is a random level generator for classic FPS titles.
The goal is to produce good levels which are fun to play.

Features of OBSIDIAN include:

* high quality levels, e.g. outdoor areas and caves!
* easy to use GUI interface (no messing with command lines)
* built-in node builder, so the levels are ready to play
* uses the LUA scripting language for easy customisation

## COMPATIBLE GAMES

* Doom 1 / The Ultimate Doom / Doom 2 / Final Doom  
  These are the primary target for Obsidian and have the highest level of support, with the most prefabs, modules, and available addons.
  New features are most likely to be implemented for these games first.
    
* Heretic  
  Moderate level of support, with some advanced modules and a handful of addons available.
  
* Chex Quest 3
  Basic level of support, with a handful of unique prefabs.
  
* HacX 1.2 
  Basic level of support.
  
* Harmony  
  Basic level of support.
  
* Hexen 
  Basic level of support. Game progression is linear and episodic, with no hubs present. The game will end after the last level generated. The Death Wyvern is absent from the monster table due to the    infeasibility of scripting and flight pathing with randomly generated layouts.
  
* Strife
  Basic level of support. Quests/multiple endings not yet implemented. Progression is linear and game will end after the last level generated.
  
* Wolfenstein 3D / Spear of Destiny
  Moderate level of support.
  
* Super Noah's Ark 3D  
  Basic level of support. 

## QUICK START GUIDE (Windows)

First, unpack the zip somewhere .  Make sure it is extracted with folders, and also make sure the OBSIDIAN.EXE file gets extracted too.

Double click on the OBSIDIAN icon to run it.  Select the game in the top left panel, and any other options which take your fancy. Then click the BUILD button in the top left panel, and pick a location in which to save your file.

OBSIDIAN will then build all the maps, showing a blueprint of each one as it goes, and if everything goes smoothly the output file (e.g. "TEST.WAD") will be created at the end.  Then you can play it using the normal method for playing mods with that game (e.g. for DOOM source ports: dragging-n-dropping the WAD file onto the source port's EXE is usually enough).

## QUICK START GUIDE (Linux/BSD/Haiku OS)

Please refer to COMPILING.md to build Obsidian for Linux/BSD/Haiku OS

## About This Repository

This is a community continuation of the OBLIGE Level Maker, originally created by Andrew Apted.

A brief summary of changes:

Improved internationalization support, including fixes for accented characters in Windows filepaths and an updated translation template

Russian translation file provided for the RU locale

GUI Customization and Theming added

Modified SLUMP level builder included for Vanilla Doom usage.

ZDBSP as the internal nodebuilder, replacing GLBSP.

UDMF map output for compatible engines.

64-bit seeds and random numbers.

Migrated from Lua to LuaJIT for improved build speeds.

Patch by Simon-v for searching for .pk3 addons in both the install and user's home directories (https://github.com/dashodanger/Oblige/pull/1)

Strings allowed for seed input (numbers with no other characters still processed as numbers).

New random number generator based on the xoshiro256 algorithm from fastPRNG (https://github.com/BrutPitt/fastPRNG).

Bugfixes as discovered.
