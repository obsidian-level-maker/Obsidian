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

  gui.set_colormap(1, STAR_COLS)

  for _,sky in ipairs(sky_list) do
    gui.fsky_create(256, 128, sky.test)
    gui.fsky_add_hills { seed=sky.test, min_h=-0.2, fracdim=1.8 }
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

