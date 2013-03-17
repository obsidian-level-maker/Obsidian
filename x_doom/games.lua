----------------------------------------------------------------
--  GAME DEFINITION : DOOM, DOOM II
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2013 Andrew Apted
--  Copyright (C)      2011 Chris Pisarczyk
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

DOOM  = { }  -- common stuff

DOOM1 = { }  -- game specific stuff
DOOM2 = { }  --

TNT      = { }
PLUTONIA = { }
FREEDOOM = { }


-- skin tables
DOOM .SKINS = { }
DOOM1.SKINS = { }
DOOM2.SKINS = { }

TNT.SKINS      = { }
PLUTONIA.SKINS = { }
FREEDOOM.SKINS = { }


-- group tables
DOOM .GROUPS = { }
DOOM1.GROUPS = { }
DOOM2.GROUPS = { }

TNT.GROUPS      = { }
PLUTONIA.GROUPS = { }
FREEDOOM.GROUPS = { }


require "entities"
require "monsters"
require "weapons"
require "pickups"

require "materials"
require "themes"
require "levels"



DOOM.PARAMETERS =
{
  rails = true
  infighting = true
  raising_start = true
---!!!  light_brushes = true

  jump_height = 24

  map_limit = 12800

  -- this is roughly how many characters can fit on the
  -- intermission screens (the CWILVxx patches).  It does not
  -- reflect any buffer limits in the DOOM.EXE
  max_name_length = 28

  skip_monsters = { 15,25,35 }

  time_factor   = 1.0
  damage_factor = 1.0
  ammo_factor   = 1.0
  health_factor = 0.7
  monster_factor = 0.9
}

DOOM2.PARAMETERS =
{
  doom2_monsters = true
  doom2_weapons  = true
  doom2_skies    = true  -- RSKY# patches

  skip_monsters = { 20,30,45 }
}


----------------------------------------------------------------

DOOM.SKIN_DEFAULTS =
{
  tex_STARTAN3  = "?wall"
  flat_FLOOR5_3 = "?wall"

  tex_BLAKWAL1  = "?outer"

  flat_FLOOR0_6 = "?floor"
}


--[[
DOOM.SKINS.Secret_Mini =
{
  prefab = "SECRET_MINI"
  shape  = "I"
  tags   = 1

  pic   = "O_NEON"
  inner = "COMPSPAN"
  metal = "METAL"
}
--]]


----------------------------------------------------------------

DOOM.PLAYER_MODEL =
{
  doomguy =
  {
    stats   = { health=0 }
    weapons = { pistol=1, fist=1 }
  }
}


------------------------------------------------------------


DOOM.LEVEL_GFX_COLORS =
{
  gold   = { 0,47,44, 167,166,165,164,163,162,161,160, 225 }
  silver = { 0,246,243,240, 205,202,200,198, 196,195,194,193,192, 4 }
  bronze = { 0,2, 191,188, 235,232, 221,218,215,213,211,209 }
  iron   = { 0,7,5, 111,109,107,104,101,98,94,90,86,81 }
}


function DOOM.make_cool_gfx()
  local GREEN =
  {
    0, 7, 127, 126, 125, 124, 123,
    122, 120, 118, 116, 113
  }

  local BRONZE_2 =
  {
    0, 2, 191, 189, 187, 235, 233,
    223, 221, 219, 216, 213, 210
  }

  local RED =
  {
    0, 2, 188,185,184,183,182,181,
    180,179,178,177,176,175,174,173
  }


  local colmaps =
  {
    BRONZE_2, GREEN, RED,

    DOOM.LEVEL_GFX_COLORS.gold,
    DOOM.LEVEL_GFX_COLORS.silver,
    DOOM.LEVEL_GFX_COLORS.iron,
  }

  rand.shuffle(colmaps)

  gui.set_colormap(1, colmaps[1])
  gui.set_colormap(2, colmaps[2])
  gui.set_colormap(3, colmaps[3])
  gui.set_colormap(4, DOOM.LEVEL_GFX_COLORS.iron)

  -- patches (CEMENT1 .. CEMENT4)
  gui.wad_logo_gfx("WALL52_1", "p", "PILL",   128,128, 1)
  gui.wad_logo_gfx("WALL53_1", "p", "BOLT",   128,128, 2)
  gui.wad_logo_gfx("WALL55_1", "p", "RELIEF", 128,128, 3)
  gui.wad_logo_gfx("WALL54_1", "p", "CARVE",  128,128, 4)

  -- flats
  gui.wad_logo_gfx("O_PILL",   "f", "PILL",   64,64, 1)
  gui.wad_logo_gfx("O_BOLT",   "f", "BOLT",   64,64, 2)
  gui.wad_logo_gfx("O_RELIEF", "f", "RELIEF", 64,64, 3)
  gui.wad_logo_gfx("O_CARVE",  "f", "CARVE",  64,64, 4)
end


function DOOM.make_level_gfx()
  assert(LEVEL.description)
  assert(LEVEL.patch)

  -- decide color set
  if not GAME.level_gfx_colors then
    local kind = rand.key_by_probs(
    {
      gold=12, silver=3, bronze=8, iron=10
    })

    GAME.level_gfx_colors = assert(DOOM.LEVEL_GFX_COLORS[kind])
  end

  gui.set_colormap(1, GAME.level_gfx_colors)

  gui.wad_name_gfx(LEVEL.patch, LEVEL.description, 1)
end


function DOOM2.end_level()
  if LEVEL.description and LEVEL.patch then
    DOOM.make_level_gfx()
  end
end


function DOOM2.all_done()
  DOOM.make_cool_gfx()

  gui.wad_merge_sections("doom_falls.wad");
  gui.wad_merge_sections("vine_dude.wad");

  if OB_CONFIG.length == "full" then
    gui.wad_merge_sections("freedoom_face.wad");
  end
end


------------------------------------------------------------


OB_GAMES["doom2"] =
{
  label = "Doom 2"

  priority = 99  -- keep at top

  format = "doom"

  tables =
  {
    DOOM, DOOM2
  }

  hooks =
  {
    get_levels = DOOM2.get_levels
    end_level  = DOOM2.end_level
    all_done   = DOOM2.all_done
  }
}


-- TODO: "doom1"

-- TODO: "ultdoom"


OB_GAMES["tnt"] =
{
  label = "TNT Evilution"

  extends = "doom2"

  tables =
  {
    TNT
  }
}


OB_GAMES["plutonia"] =
{
  label = "Plutonia Exp."

  extends = "doom2"

  tables =
  {
    PLUTONIA
  }
}


OB_GAMES["freedoom"] =
{
  label = "FreeDoom 0.7"

  extends = "doom2"

  tables =
  {
    FREEDOOM
  }
}

