# OBSIDIAN

## LUA/PREFABS/ADDON DEVELOPERS

Caligari87
  - Maintainer of Oblige 7.70 and ObAddon repositories

MsrSgtShooterPerson
  - Upstream content repository maintainer
  - Prefabs
  - Shape rules
  - Modules
  - Textures
  - Documentation

Armaetus
  - Original base tweaks to Oblige v7.59
  - Prefabs
  - Modules
  - Textures
  - Extensive name generator additions
  - IWAD Mode

Beed28
  - Prefabs

Craneo
  - Textures
  - Prefabs
  - Name generator contributions
  - Sprites
  - Improved Heretic support and additional content

Demios
  - Complex, sloped and 3D floor prefab creator
  - CSG threshold testing
  - General QA testing
  - Wiki and tutorial content

EpicTyphlosion
  - Prefabs
  - Name generator contributions

Frozsoul
  - Fauna module
  - Psychedelic theme porting
  - Prefabs
  - Most of the new GUI custom themes

Garrett
  - Prefabs

josh771
  - ZScript code for flies (from fauna module)

MogWaltz
  - Prefabs

Scionox
  - Prefabs
  - Random boss generator module

Simon-v
  - Lua normalizer
  - Story generator contributions

Tapwave
  - Story generator contributions


## GUI/MAIN PROGRAM DEVELOPERS

Dashodanger
  - 64-bit support and revamped RNG
  - ZDBSP and UDMF support
  - SLUMP integration for Vanilla Doom
  - GUI overhaul
  - Restoration of Hexen baseline functions

Phytolizer
  - Created Filename Formatter to parse custom prefixes
  - Conversion from Makefiles to CMake build system
  - MSVC support for compiling source on Windows
  - Many, many optimizations and updates of the codebase

Simon-v
  - Patch for scanning both install and home directories for addons
  - Fixing Date/Time filename prefixes to be ISO-conformant

HugLifeTiZ 
  - XDG compliance and Flatpak compatibility prep work (Linux builds)
  - Zenity File Picker patch for bundled FLTK 1.4

## COMMUNITY CONTRIBUTORS:

Cubebert
  - Chex Quest 3 canon themes and other improvements
  - Modules for newly supported games (CQ3, HacX, et al)
  - Chex Quest 3 skyboxes
  - Heretic skyboxes
  - XBox Dashboard, ZDoom Forums, and ZDoom Forums Submerged program themes

hytalego
  - Russian translation file

Twin Galaxy
  - Windows 95 program theme

WolVexus
  - Black Ops program theme

username
  - Updated tutorial imagery

Dan_The_Noob
  - "Dan The Noob" theme

Il Str
  - Discord Dark/Discord Light themes

# OBLIGE

## DEVELOPER:

Andrew Apted
  - Creator of the original OBLIGE


## CONTRIBUTORS:

Armaetus
  - DOOM prefabs
  - Skulltag Monsters module
  - ZDoom Beastiary module
  - DOOM 1 boss maps (most of them in fact)
  - DOOM 2 boss maps (e.g. "dead simple" one)
  - DOOM 1/2 theming
  - Egypt theme for TNT Evilution
  - an OBLIGE logo image
  - additions to name generator
  - lots of useful feedback
  - general encouragement and support

Derek Braun (Dittohead)
  - DOOM tech prefabs

Doctor Nick
  - Makefile.macos file

Enhas
  - ZDoom Marines module
  - Stealth Monsters module
  - Level Control module
  - various Skulltag stuff
  - psychedelic level names
  - Chex Quest game definition
  - a DOOM "gotcha" style boss map
  - lots of useful feedback
  - fixes and tweaks

Jared Blackburn (blackjar)
  - Hexen theming

Jon Vail (40oz)
  - extensive work on name generator
  - Cyberdemon arena map
  - DOOM prefabs

Sam Trenholme
  - Heretic theming
  - workaround for the stair-building error
  - lots of feedback and support
  - numerous fixes

LakiSoft
  - Heretic boss maps

SylandroProbopas
  - DOOM 1 boss map


## THANKS TO:

DoomJedi : Wolf3D testing, list of Wolf3D mods. 

esselfortium : encouragement and detailed feedback.

gggmork : beta testing, detailed feedback.

flyingdeath : various feedback and useful suggestions.

leilei : initial Amulets & Armor definition, various feedback.

Maxim Samoylenko : encouragement and testing.

thesleeve : monster placement analysis.

.... and everyone else who provided feedback, bug reports,
ideas for improvements (etc), both in email and on the forums.
Your input has been greatly appreciated!


## TITLE ARTWORK:

bg/lamp1.tga  : by Lanea Zimmerman, under CC-BY 3.0 license.
bg/block1.tga : by Keith333 (user on OGA), under CC-BY 3.0 license.
bg/block2.tga : by Tiziana, under CC-BY 3.0 license.

Several textures and sprites from the FreeDoom project.

(All other title artwork is under CC0 license / public domain)


## NOTES:

OBLIGE was written from scratch. It does not contain any code
from SLIGE (by David Chess) or from any other random level
generator. That being said, OBSIDIAN has since integrated the SLUMP
level generator, a GPL2 fork of David Chess' SLIGE that was created
by Sam Trenholme.

Part of the cave algorithm used in OBSIDIAN was described by Jim
Babcock in his article: "Cellular Automata Method for Generating
Random Cave-Like Levels".

The internal font loading code is derived from a post by Ian MacArthur
in a Google Groups thread at the following link:
https://groups.google.com/g/fltkgeneral/c/uAdg8wOLiMk

OBSIDIAN uses Lua 5.4.x (http://www.lua.org)

OBSIDIAN uses FLTK 1.3.x (http://www.fltk.org)

