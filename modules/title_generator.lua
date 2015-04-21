----------------------------------------------------------------
--  MODULE: title-pic generator
----------------------------------------------------------------
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
----------------------------------------------------------------

TITLE_GEN = { }


function TITLE_GEN.generate_title()
  assert(GAME.title)

  -- don't bother for a single map
  if OB_CONFIG.length == "single" then
    return
  end

  -- TODO
end


----------------------------------------------------------------

OB_MODULES["title_generator"] =
{
  label = "Title Generator"

  game = { doom1=1, doom2=1 }

  hooks =
  {
    all_done = TITLE_GEN.generate_title
  }
}

