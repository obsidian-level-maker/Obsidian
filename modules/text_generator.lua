------------------------------------------------------------------------
--  MODULE: Text Generator
------------------------------------------------------------------------
--
--  Copyright (C) 2016 Andrew Apted
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

TEXT_GEN = {}


function TEXT_GEN.generate_texts()
  local sec1 = namelib.generate("TEXT_SECRET",  1, 500)
  local sec2 = namelib.generate("TEXT_SECRET2", 1, 500)

  GAME.secret_text  = sec1[1]
  GAME.secret2_text = sec2[1]

  -- TODO : an actual story for the other texts

  GAME.episodes[1].mid_text = "Middler....."

  each EPI in GAME.episodes do
    EPI.end_text = "Blah blah..."
  end
end


OB_MODULES["text_generator"] =
{
  label = _("Text Generator")
  priority = 84

  game = "doomish"
  engine = "boom"

  hooks =
  {
    get_levels = TEXT_GEN.generate_texts
  }
}

