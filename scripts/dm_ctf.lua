------------------------------------------------------------------------
--  DEATH-MATCH / CAPTURE THE FLAG
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2015 Andrew Apted
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
------------------------------------------------------------------------


function Multiplayer_create_zones()
  --
  -- In competitive multiplayer maps we only need a single zone.
  --

  local Z = Zone_new()

  each R in LEVEL.rooms do
    R.zone = Z

    each A in R.areas do
      A.zone = Z
    end
  end

  Area_spread_zones()
end



function Multiplayer_setup_level()

  Multiplayer_create_zones()

  Quest_choose_themes()
  Quest_select_textures()

  -- FIXME : flag rooms for CTF

  -- FIXME : player starts

  -- FIXME : weapons
end

