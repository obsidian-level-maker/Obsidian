
# OBLIGE 7.70
by Andrew Apted.


## INTRODUCTION

OBLIGE is a random level generator for the classic FPS 'DOOM'.
The goal is to produce good levels which are fun to play.

Features of OBLIGE include:

* high quality levels, e.g. outdoor areas and caves!
* easy to use GUI interface (no messing with command lines)
* built-in node builder, so the levels are ready to play
* uses the LUA scripting language for easy customisation

## QUICK START GUIDE

First, unpack the zip somewhere (e.g. My Documents).  Make sure it is extracted with folders, and also make sure the OBLIGE.EXE file gets extracted too (at least one person had a problem where Microsoft Windows would skip the EXE, and he had to change something in the control panels to get it extracted properly).

Double click on the OBLIGE icon to run it.  Select the game in the top left panel, and any other options which take your fancy. Then click the BUILD button in the bottom left panel, and enter an output filename, for example "TEST" (without the quotes).

OBLIGE will then build all the maps, showing a blueprint of each one as it goes, and if everything goes smoothly the output file (e.g. "TEST.WAD") will be created at the end.  Then you can play it using the normal method for playing mods with that game (e.g. for DOOM source ports: dragging-n-dropping the WAD file onto the source port's EXE is usually enough).

## About This Repository

This is a fork containing some changes and updates to Oblige, as well as some quality of life fixes. Since then, I have successfully tested it with Linux and Win10 x86_64. It is also compatible with ObAddon and will load it from a .pk3 file via the Addons menu.

A brief summary of changes:

Overhaul of Lua-related scripts and functions to support Lua 5.4.x (in progress)

Patch by Simon-v for searching for .pk3 addons in both the install and user's home directories (https://github.com/dashodanger/Oblige/pull/1)

Strings allowed for seed input (numbers with no other characters still processed as numbers).

New random number generator based on the Mersenne Twister Engine.

Updated PHYSFS to version 3.02.

Updated deprecated PHYSFS function calls with their replacements.

Replaced GLBSP 2.27 with GLBSP 2.28 from the EDGE project (https://https://github.com/3dfxdev/EDGE)

Added scrolling functionality to Addons List window.

Added preservation of action specials when converting Hexen linedefs.

Added library sources needed to cross-compile for Windows using MinGW.

Minor bugfixes as discovered.
