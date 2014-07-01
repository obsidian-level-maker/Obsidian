--------------------------------------------------------------------
--  DOOM RESOURCES / GRAFIX
--------------------------------------------------------------------
--
--  Copyright (C) 2006-2013 Andrew Apted
--  Copyright (C)      2011 Chris Pisarczyk
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
--------------------------------------------------------------------

DOOM.LEVEL_GFX_COLORS =
{
  gold   = { 0,47,44, 167,166,165,164,163,162,161,160, 225 }
  silver = { 0,246,243,240, 205,202,200,198, 196,195,194,193,192, 4 }
  bronze = { 0,2, 191,188, 235,232, 221,218,215,213,211,209 }
  iron   = { 0,7,5, 111,109,107,104,101,98,94,90,86,81 }

  red    = { 0,2, 191,189,187,185,183,181,179 }
  black  = { 0,0,0,0, 0,0,0,0 }
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
    180,179,178,177,176,175,174,173,172
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
  gui.set_colormap(5, DOOM.LEVEL_GFX_COLORS.black)

  -- patches (CEMENT1 .. CEMENT4)
  gui.wad_logo_gfx("WALL52_1", "p", "PILL",   128,128, 1)
  gui.wad_logo_gfx("WALL53_1", "p", "BOLT",   128,128, 2)
  gui.wad_logo_gfx("WALL55_1", "p", "RELIEF", 128,128, 3)
  gui.wad_logo_gfx("WALL54_1", "p", "CARVE",  128,128, 4)
  gui.wad_logo_gfx("WALL52_2", "p", "CARVE",  128,128, 5)

  -- flats
  gui.wad_logo_gfx("O_PILL",   "f", "PILL",   64,64, 1)
  gui.wad_logo_gfx("O_BOLT",   "f", "BOLT",   64,64, 2)
  gui.wad_logo_gfx("O_RELIEF", "f", "RELIEF", 64,64, 3)
  gui.wad_logo_gfx("O_CARVE",  "f", "CARVE",  64,64, 4)
  gui.wad_logo_gfx("O_BLACK",  "f", "CARVE",  64,64, 5)
end


function DOOM.make_level_gfx()
  -- decide color set
  if not GAME.level_gfx_colors then
    local kind = rand.key_by_probs(
    {
      gold=12, silver=3, bronze=8, iron=10
    })

    GAME.level_gfx_colors = assert(DOOM.LEVEL_GFX_COLORS[kind])
  end

  gui.set_colormap(1, GAME.level_gfx_colors)

  if LEVEL.patch and LEVEL.description then
    gui.wad_name_gfx(LEVEL.patch, LEVEL.description, 1)
  end
end


function DOOM.make_episode_gfx()
  local colors = assert(DOOM.LEVEL_GFX_COLORS["red"])

  gui.set_colormap(2, colors)

  for idx = 1, 4 do
    local EPI = GAME.episodes[idx]
    assert(EPI)

    if EPI.name_patch and EPI.description then
      gui.wad_name_gfx(EPI.name_patch, EPI.description, 2)
    end
  end
end


function DOOM1.end_level()
  DOOM.make_level_gfx()
end


function DOOM2.end_level()
  DOOM.make_level_gfx()
end


function DOOM1.all_done()
  DOOM.make_cool_gfx()
  DOOM.make_episode_gfx()

  gui.wad_merge_sections("doom_falls.wad");
  gui.wad_merge_sections("metal_step.wad");
  gui.wad_merge_sections("short_bars.wad");
end


function DOOM2.all_done()
  DOOM.make_cool_gfx()

  gui.wad_merge_sections("doom_falls.wad");
  gui.wad_merge_sections("metal_step.wad");
  gui.wad_merge_sections("vine_dude.wad");
  gui.wad_merge_sections("parrot.wad");

  if OB_CONFIG.length == "game" then
    gui.wad_merge_sections("freedoom_face.wad");
  end
end

