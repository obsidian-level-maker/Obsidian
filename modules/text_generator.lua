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


function TEXT_GEN.create_story(num_parts)
  -- FIXME
  return { "a", "b", "c", "d", "e", "f", "g", "h" }
end


function TEXT_GEN.handle_secrets()
  local list1 = namelib.generate("TEXT_SECRET",  1, 500)
  local list2 = namelib.generate("TEXT_SECRET2", 1, 500)

  GAME.secret_text  = list1[1]
  GAME.secret2_text = list2[1]
end


function TEXT_GEN.generate_texts()
  -- count needed parts (generally 3 or 4)
  local num_parts = 0

  each EPI in GAME.episodes do
    if EPI.bex_mid_name then num_parts = num_parts + 1 end
    if EPI.bex_end_name then num_parts = num_parts + 1 end
  end

stderrf("num_parts = %d\n", num_parts)

  if num_parts == 0 then return end

  local texts = TEXT_GEN.create_story(num_parts)

  local function get_part()
    return table.remove(texts, 1)
  end

  each EPI in GAME.episodes do
    if EPI.bex_mid_name then EPI.mid_text = get_part() end
    if EPI.bex_end_name then EPI.end_text = get_part() end
  end

  TEXT_GEN.handle_secrets()
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

