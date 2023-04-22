----------------------------------------------------------------
--  MODULE: ZDoom Story Generator
----------------------------------------------------------------
--
--  Copyright (C) 2019-2022 MsrSgtShooterPerson
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
-------------------------------------------------------------------

function ZStoryGen_format_story_chunk(story_strings, info, store)

  local line_max_length = 38

  -- replace special word tags with their proper ones from the name gen
  if info then

    if info.enemy_name == "NOUNMEMBERS" then
      info.enemy_name = info.contributor_name
    end

    if store and PARAM.bool_boss_gen == 1 then
      local mcevil
      if string.find(story_strings, "_RAND_ENEMY") and info.enemy_name then
        mcevil = info.enemy_name
        if string.find(story_strings, "_EVULZ") then
          mcevil = mcevil .. " the " .. info.enemy_title
        elseif string.find(story_strings, "_LEVEL") then
          mcevil = mcevil .. " of " .. info.level_name
        end
        if PARAM.epi_names[store] == nil then
          PARAM.epi_names[store] = mcevil
        end
      end
    end

    if info.enemy_name then
      story_strings = string.gsub(story_strings, "_RAND_ENEMY", info.enemy_name)
    end
    story_strings = string.gsub(story_strings, "_RAND_ENGLISH_PLACE", info.anglican_name)
    story_strings = string.gsub(story_strings, "_EVULZ", info.enemy_title)
    if info.level_name then
      story_strings = string.gsub(story_strings, "_LEVEL", info.level_name)
    end
    story_strings = string.gsub(story_strings, "_RAND_CONTRIBUTOR", info.contributor_name)
    if info.mcguffin then
      story_strings = string.gsub(story_strings, "_MCGUFFIN", info.mcguffin)
    end
    if info.entity then
      story_strings = string.gsub(story_strings, "_RAND_ENTITY", info.entity)
    end
    if info.installation then
      story_strings = string.gsub(story_strings, "_INSTALLATION", info.installation)
    end
  end

  -- dialogue quotes and apostrphes, man
  story_strings = string.gsub(story_strings, '\"', "'")

  -- remove the spaces left behind by Lua's square bracket stuff.
  story_strings = string.gsub(story_strings, "  ", "")
  story_strings = string.gsub(story_strings, "\n", " ")

  -- ensure words are always within the width of Doom's intermission screens
  -- based on the above defined line_max_length
  local i = 1
  local manhandled_string = ''
  local manhandled_string_length = 0
  local story_lines = {}


  -- splitting dem paragraphs
  for word in story_strings:gmatch("%S+") do

    if manhandled_string_length == 0 then
      manhandled_string = '"' .. manhandled_string
    end

    if word == "_SPACE" then
      word = "\\n\\n"
    end

    manhandled_string_length = manhandled_string_length + word:len()

    -- do a line break if the word gets the line to be longer than
    -- the allowed maximum length
    if manhandled_string_length + word:len() > line_max_length then
      manhandled_string = manhandled_string .. '\\n"'
      table.insert(story_lines, manhandled_string)
      manhandled_string = '"' .. word .. ' '
      manhandled_string_length = word:len()
    else
      if word ~= "\\n\\n" then
        manhandled_string = manhandled_string .. word .. " "
      else
        -- line breaks aren't words, bruh
        manhandled_string = manhandled_string .. word
        manhandled_string_length = line_max_length
      end
    end
  end

  -- properly add the last line if it exists.
  if manhandled_string ~= "" then
    table.insert(story_lines, manhandled_string .. '"')
  end
  story_lines[#story_lines] = story_lines[#story_lines] .. ";"

  return story_lines
end

function ZStoryGen_fetch_story_chunk()
  return rand.key_by_probs(GAME.STORIES.LIST)
end

function ZStoryGen_create_characters_and_stuff(lev_info)
  local info = { }

  if lev_info then
    info.level_name = lev_info.description
  end

  -- some names based on the namelib need to pass through the unique noun generator on
  -- the occasion it picks up the noun gen keywords, or the keywords will
  -- stay as they are in the string
  info.anglican_name = namelib.generate_unique_noun("anglican")
  info.enemy_title = rand.key_by_probs(GAME.STORIES.EVIL_TITLES)
  info.contributor_name = rand.pick(namelib.COMMUNITY_MEMBERS.contributors)
  if GAME.STORIES.INSTALLATIONS then
    info.installation = rand.key_by_probs(GAME.STORIES.INSTALLATIONS)
  end

  return info
end

function ZStoryGen_hook_me_with_a_story(story_id, info, epi)
  local story_chunk = GAME.STORIES.TEXT[story_id]
  local story_string = rand.pick(story_chunk.hooks)
  local story_table = ZStoryGen_format_story_chunk(story_string, info, epi)
  return story_table
end

function ZStoryGen_conclude_my_story(story_id, info, epi)
  local story_chunk = GAME.STORIES.TEXT[story_id]
  local story_string = rand.pick(story_chunk.conclusions)
  local story_table = ZStoryGen_format_story_chunk(story_string, info, epi)
  return story_table
end

function ZStoryGen_init()

  gui.printf("\n--== ZDoom: Story generator ==--\n\n")

  local hooks = {}
  local conclusions = {}
  local x = 1
  PARAM.language_lump = {}

  while x <= #GAME.episodes do
    local story_id = ZStoryGen_fetch_story_chunk()
    local info = ZStoryGen_create_characters_and_stuff()
    if GAME.STORIES.TEXT[story_id].enemy_theme then
      local enemy_name = rand.key_by_probs(namelib.NAMES[GAME.STORIES.TEXT[story_id].enemy_theme].lexicon.e)
      enemy_name = string.gsub(enemy_name, "NOUNGENEXOTIC", namelib.generate_unique_noun("exotic"))
      info.enemy_name = enemy_name
    end
    if GAME.STORIES.TEXT[story_id].level_theme then
      info.level_name = Naming_grab_one(GAME.STORIES.TEXT[story_id].level_theme)
    end
    if GAME.STORIES.TEXT[story_id].mcguffin_theme then
      info.mcguffin = rand.key_by_probs(GAME.STORIES.MCGUFFINS[GAME.STORIES.TEXT[story_id].mcguffin_theme])
    end
    if GAME.STORIES.TEXT[story_id].entity_theme then
      info.entity = rand.key_by_probs(GAME.STORIES.ENTITIES[story_id].entity_theme)
    end
    hooks[x] = ZStoryGen_hook_me_with_a_story(story_id, info, x)
    conclusions[x] = ZStoryGen_conclude_my_story(story_id, info, x)
    x = x + 1
  end


  -- create language lump
  table.insert(PARAM.language_lump, "// The following stories are brought to you by\n")
  table.insert(PARAM.language_lump, "// the ObAddon Story Generator!\n")
  table.insert(PARAM.language_lump, "\n")


  -- attach game title and subtitle
  table.insert(PARAM.language_lump, "GAME_TITLE = " .. "\"" .. GAME.title .. "\";\n\n")
  if GAME.sub_title then
    table.insert(PARAM.language_lump, "GAME_SUB_TITLE = " .. "\"" .. GAME.sub_title .. "\";\n\n")
  end

  x = 1
  local y
  while x <= #GAME.episodes do

    -- insert story start sequence
    table.insert(PARAM.language_lump, "STORYSTART" .. x .. " =\n")
    for _,line in pairs(hooks[x]) do
      table.insert(PARAM.language_lump, "  " .. line .. "\n")
    end
    table.insert(PARAM.language_lump, "\n")

    -- insert story end sequences
    table.insert(PARAM.language_lump, "STORYEND" .. x .. " =\n")
    for _,line in pairs(conclusions[x]) do
      table.insert(PARAM.language_lump, "  " .. line .. "\n")
    end
    table.insert(PARAM.language_lump, "\n")
    x = x + 1
  end


  -- create secret messages
  local secret_entry = ZStoryGen_format_story_chunk(rand.pick(GAME.STORIES.SECRET_TEXTS.secretnearby))
  local secret1 = ZStoryGen_format_story_chunk(rand.pick(GAME.STORIES.SECRET_TEXTS.secret1))
  local secret2 = ZStoryGen_format_story_chunk(rand.pick(GAME.STORIES.SECRET_TEXTS.secret2))
  table.insert(PARAM.language_lump, "SECRETNEARBY =\n")
  for _,line in pairs(secret_entry) do
    table.insert(PARAM.language_lump, "  " .. line .. "\n")
  end
  table.insert(PARAM.language_lump, "\n")
  table.insert(PARAM.language_lump, "SECRET1 =\n")
  for _,line in pairs(secret1) do
    table.insert(PARAM.language_lump, "  " .. line .. "\n")
  end
  table.insert(PARAM.language_lump, "\n")
  table.insert(PARAM.language_lump, "SECRET2 =\n")
  for _,line in pairs(secret2) do
    table.insert(PARAM.language_lump, "  " .. line .. "\n")
  end

end

function ZStoryGen_quitmessages()
  PARAM.quit_messagelump = {
  "\n",
  }
  -- custom quit message creation
  PARAM.bool_quit_messages = 1
  if PARAM.bool_quit_messages == 1 then
    x = 1
    local info = ZStoryGen_create_characters_and_stuff()
    local name_picks = {}
    for k,_ in pairs(GAME.THEMES) do
      if k ~= "DEFAULTS" then table.add_unique(name_picks, k) end
    end
    local name_theme = rand.pick(name_picks)
    info.level_name = Naming_grab_one(OB_THEMES[name_theme].name_class)
    local enemy_name = rand.key_by_probs(namelib.NAMES["TITLE"].lexicon.e)
    if namelib.NAMES[OB_THEMES[name_theme].name_class].lexicon.e then
      enemy_name = rand.key_by_probs(namelib.NAMES[OB_THEMES[name_theme].name_class].lexicon.e)
    end
    enemy_name = string.gsub(enemy_name, "NOUNGENEXOTIC", namelib.generate_unique_noun("exotic"))
    info.enemy_name = enemy_name 
    for _,line in pairs(GAME.STORIES.QUIT_MESSAGES) do
      line = ZStoryGen_format_story_chunk(line, info)
      table.insert(PARAM.quit_messagelump, "\nQUITMSG" .. x .. " =\n")
      x = x + 1
      for _,o_line in pairs(line) do
        table.insert(PARAM.quit_messagelump, "  " .. o_line .. "\n")
      end
    end
  end
end

-- LOOK AT ALL THIS CODE NOW
-- SO HAPPY ALEXA PLAY D_RUNNIN
