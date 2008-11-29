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
  -- FIXME
end


OB_MODULES["sky_gen_doom"] =
{
  label = "Sky Generator",

  for_games = { doom2=1, doom1=1, freedoom=1 },

  hooks =
  {
    generate_skies = Doom_generate_skies,
  },
}

