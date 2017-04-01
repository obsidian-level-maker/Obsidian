------------------------------------------------------------------------
--  Story Text Generator
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

STORY_GEN = {}


function STORY_GEN.generate_story()

  local info = {}


  local MAX_WIDTH = 35

  local WIDTH_TABLE =
  {
    [' '] = 0.6
    ['.'] = 0.6
    [','] = 0.6
    ['!'] = 0.6
    ['\''] = 0.6
    ['i'] = 0.6
    ['I'] = 0.6
  }

  local function estimate_width(line)
    local width = 0

    for i = 1, #line do
      local ch = string.sub(line, i, i)

      width = width + (WIDTH_TABLE[ch] or 1.0)
    end

    return width
  end


  local function do_substitutions(text)
    -- perform some replacements (e.g. name of the big boss)

    -- FIXME

    return text
  end


  local function format_text(raw_text)
    -- Convert the unformatted text to a formatted one, splitting
    -- lines which are too long to fit on the screen.
    -- [ and capitalising words that begin a new sentence ??? ]
    --
    -- We handle a few special symbols:
    --    '|' begins a new paragraph.
    --

    local text = ""

    local function add_line(line)
      if text != "" then text = text .. "\n" end
      text = text .. line
    end

    local function maybe_add_line(line)
      if line != "" then add_line(line) end
    end

    local cur_line = ""
    local new_line

    each word in string.tokenize(raw_text) do
      if string.sub(word, 1, 1) == '|' then
        maybe_add_line(cur_line)
        add_line("")

        cur_line = string.sub(word, 2)
        continue
      end

      if cur_line == "" then
        new_line = word
      else
        new_line = cur_line .. " " .. word
      end

      local e1 = estimate_width(cur_line)
      local e2 = estimate_width(new_line)

      if e2 < MAX_WIDTH then
        cur_line = new_line
        continue
      end

      maybe_add_line(cur_line)

      cur_line = word
    end

    maybe_add_line(cur_line)

    return text
  end


  local function validate_screen(text)
    -- check that the screen is not too long

    local s, num_lines = string.gsub(text, "\n", "\n")

    num_lines = num_lines + 1

--stderrf("num_lines = %d\n", num_lines)

    if num_lines > PARAM.max_screen_lines then
      return false
    end

    return true
  end


  local function make_a_screen(where)
    -- where can be: "first", "last" or "middle".

    -- FIXME

    if where == "first" then return "Firstly...." end
    if where == "last"  then return "T H E ... E N D" end

    return "zzzzz"
  end


  local function create_story(num_parts)

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
        text = make_a_screen(where)
        text = format_text(do_substitutions(text))

        if validate_screen(text) then
          break;
        end
      end

      table.insert(parts, text)
    end

    return parts
  end


  local function handle_main_texts()
    -- count needed parts (generally 3 or 4)
    local num_parts = 0

    each EPI in GAME.episodes do
      if EPI.bex_mid_name then num_parts = num_parts + 1 end
      if EPI.bex_end_name then num_parts = num_parts + 1 end
    end

--stderrf("num_parts = %d\n", num_parts)

    if num_parts == 0 then return end

    local texts = create_story(num_parts)

    local function get_part()
      return table.remove(texts, 1)
    end

    each EPI in GAME.episodes do
      if EPI.bex_mid_name then EPI.mid_text = get_part() end
      if EPI.bex_end_name then EPI.end_text = get_part() end
    end
  end


  local function handle_secrets()
    local list1 = namelib.generate("TEXT_SECRET",  1, 500)
    local list2 = namelib.generate("TEXT_SECRET2", 1, 500)

    -- we assume secret texts will be valid (not too long)

    GAME.secret_text  = format_text(do_substitutions(list1[1]))
    GAME.secret2_text = format_text(do_substitutions(list2[1]))
  end


  ---| Story_generate |---

  handle_main_texts()
  handle_secrets()
end

