------------------------------------------------------------------------
--  HERETIC RESOURCES and GFX
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2012 Andrew Apted
--  Copyright (C)      2008 Sam Trenholme
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

function HERETIC.make_cool_gfx()
  local GREEN =
  {
    0, 209, 211, 213, 215, 217, 218
  }

  local BROWN =
  {
    0, 66, 68, 70, 73, 76, 79, 82, 86, 90
  }

  local RED =
  {
    0, 251, 253, 145, 147, 149, 151, 153, 155, 157
  }

  local WHITE =
  {
    0,2,4,6,8,10,12, 14,16,18,20,22,24
  }

  local BLUE =
  {
    0, 185, 187, 189, 191, 194, 197, 199, 202
  }


  local colmaps =
  {
    GREEN, BROWN, RED, BLUE
  }

  rand.shuffle(colmaps)

  gui.set_colormap(1, colmaps[1])
  gui.set_colormap(2, colmaps[2])
  gui.set_colormap(3, colmaps[3])
  gui.set_colormap(4, WHITE)

  local carve = "RELIEF"
  local c_map = 3

  if rand.odds(33) then
    carve = "CARVE"
    c_map = 4
  end

  -- patches for SKULLSB2, CHAINSD
  gui.wad_logo_gfx("WALL41", "p", "PILL",  128,128, 1)
  gui.wad_logo_gfx("WALL42", "p", carve,    64,128, c_map)

  -- flats
  gui.wad_logo_gfx("O_BOLT",  "f", "BOLT",  64,64, 2)
  gui.wad_logo_gfx("O_PILL",  "f", "PILL",  64,64, 1)
  gui.wad_logo_gfx("O_CARVE", "f", carve,   64,64, c_map)
end


function HERETIC.all_done()
  HERETIC.make_cool_gfx()
end

