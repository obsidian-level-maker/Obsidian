------------------------------------------------------------------------
--  HEXEN RESOURCES and GFX
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2011 Andrew Apted
--  Copyright (C) 2011-2012 Jared Blackburn
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

function HEXEN.make_cool_gfx()
  local PURPLE =
  {
    0, 231, 232, 233, 234, 235, 236, 237, 238, 239
  }

  local GREEN =
  {
    0, 186, 188, 190, 192, 194, 196, 198, 200, 202
  }

  local BROWN =
  {
    0, 97, 99, 101, 103, 105, 107, 109, 111, 113, 115, 117, 119, 121
  }

  local RED =
  {
    0, 164, 166, 168, 170, 172, 174, 176, 178, 180, 183
  }

  local WHITE =
  {
    0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30
  }

  local BLUE =
  {
    0, 146, 148, 150, 152, 154, 156, 217, 219, 221, 223
  }


  local colmaps =
  {
    PURPLE, GREEN, BROWN, RED, BLUE
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

  -- patches : SEWER08, BRASS3, BRASS4
  gui.wad_logo_gfx("W_121", "p", "BOLT",  64,128, 1)
  gui.wad_logo_gfx("W_320", "p", "PILL", 128,128, 2)
  gui.wad_logo_gfx("W_321", "p", carve,  128,128, c_map)

  -- flats
  gui.wad_logo_gfx("O_BOLT",  "f", "BOLT",  64,64, 1)
  gui.wad_logo_gfx("O_PILL",  "f", "PILL",  64,64, 2)
  gui.wad_logo_gfx("O_CARVE", "f", carve,   64,64, c_map)
end


function HEXEN.all_done()
  HEXEN.make_mapinfo()
  HEXEN.make_cool_gfx()
end

