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


function TEXT_GEN.make_a_screen(info, where)
  -- where can be: "first", "last" or "middle"

  -- FIXME

  if where == "first" then return "Firstly...." end
  if where == "last"  then return "T H E    E N D" end

  return "Middly......."
end


function TEXT_GEN.validate_screen(text)
  -- check the screen is not too long

  -- FIXME

  return true
end


function TEXT_GEN.create_story(num_parts)
  local info  = {}

  -- TODO : decide some story elements (like who's the boss)

  local parts = {}

  for i = 1, num_parts do
    local where

    -- a single part is treated as the final screen
        if i >= num_parts then where = "last"
    elseif i <= 1 then where = "first"
    else where = "middle"
    end

    local text

    for loop = 1,20 do
      text = TEXT_GEN.make_a_screen(info, where)

      if TEXT_GEN.validate_screen(text) then
        break;
      end
    end

    table.insert(parts, text)
  end

  return parts
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

