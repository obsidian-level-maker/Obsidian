# ZokumBSP 

## Author
(c) 2016-2018 Kim Roar Foldøy Hauge, (c) 1994-2004 Marc Rousseau

## Description

ZokumBSP is an advanced node/blockmap builder for Doom / Doom 2.
It should also build Heretic and Hexen maps, but this is untested.
Based on ZenNode 1.2.0 and available from GitHub.

This is a work in progress and is an experimental node builder.

## Project goals

A node / blockmap / reject builder that allows for larger maps that
are compatible with the classic Doom MS-DOS executables and with the
Chocolate Doom project.

## Compatibility

It can produce compressed blockmaps that are compatible with the
original Id Software blockmaps that should ensure 100% demo playback
compatibility. It can also produce blockmaps that are compatible with
ZenNode 1.2.0 and BSP blockmaps, but with a possibly smaller size.

The Blockmap in the original 'vanilla' Doom MS-DOS executable has an
upper limit of about 65 kilobyte. Bigger blockmaps would lead to the
game crashing, putting an upper limit on the complexity and size of
the maps one can create.

By using better algorithms, some tricks and the added option of
brute force testing up to 65k different blockmap offsets one can
generate blockmaps that are significantly smaller than what was
possible with ZenNode, BSP or Id's original node builder.

Use the -bi+ switch to build blockmaps that can replace the
original blockmaps. The quality of compatibility has been tested
mostly with multiple compet-n demos of multilevel recordings.
Primarily 30nm2039.lmp, 30ns6155.lmp and 30famax2.lmp

## Project web page

http://www.doom2.net/zokum/zokumbsp/

## Usage

```
ZokumBSP Version: 1.0.x branch (c) 2016-2018 Kim Roar Foldøy Hauge
Based on: ZenNode Version 1.2.1 (c) 1994-2004 Marc Rousseau

Usage: zokumbsp {-options} filename[.wad] [level{+level}] {-o|x output[.wad]}

See the documentation file zokumbsp.txt for more information.

```
