----------------------------------------------------------------
--  MODULE: sky generator
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2008 Andrew Apted
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


function Doom_generate_skies()
  local sky_list =  -- FIXME !!!! game specific
  {
    { patch="RSKY1", test=0xc4 },
    { patch="RSKY2", test=0 },
    { patch="RSKY3", test=0xb8 },
  }

  local STAR_COLS =
  {
    8, 7, 6, 5,
    111, 109, 107, 104, 101,
    98, 95, 91, 87, 83,
    4
  }

  local GREY_CLOUDS =
  {
    106,104,102,100,
    98,96,94,92,90,
    88,86,84,82,80
  }

  local HELL_CLOUDS =
  {
    188,185,184,183,182,181,180,
    179,178,177,176,175,174,173
  }

  local BLUE_CLOUDS =
  {
    245,245,244,244,243,242,241,
    240,206,205,204,204,203,203
  }

  local BROWN_HILLS =
  {
    0, 2, 1,
    79, 77, 75, 73, 70, 67, 64,
  }

  local GREEN_HILLS =
  {
    0, 7,
    127, 126, 125, 124, 123, 122, 120, 118, 116, 113
  }

  local HELL_HILLS =
  {
    0, 6,
    47, 45, 43, 41, 39, 37, 35, 33
  }

  gui.set_colormap(1, BLUE_CLOUDS)
  gui.set_colormap(2, GREEN_HILLS)

  for num,sky in ipairs(sky_list) do
    gui.fsky_create(256, 128, sky.test)
--  gui.fskt_add_stars  { seed=num+9, colmap=2 }
    gui.fsky_add_clouds { seed=num+1, colmap=1, squish=2.0 }
    gui.fsky_add_hills  { seed=num+5, colmap=2 }
    gui.fsky_write(sky.patch)
  end
end


OB_MODULES["sky_gen_doom"] =
{
  label = "Sky Generator (DOOM)",

  for_games = { doom2=1, doom1=1, freedoom=1 },

  hooks =
  {
    generate_skies = Doom_generate_skies,
  },
}

