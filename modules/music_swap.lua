------------------------------------------------------------------------
--  MODULE: Music Swapping for DOOM
------------------------------------------------------------------------
--
--  Copyright (C) 2014 Andrew Apted
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
------------------------------------------------------------------------

MUSIC_SWAP = {}


-- Notes:
--   1. these music lists exclude boss maps.
--
--   2. they are organized into episodes, and songs are only swapped
--      within an episode (never between them).  That is because
--      later episodes generally re-use songs from earlier ones, to
--      to avoid getting the same song two (or three!) times in a row.
--

MUSIC_SWAP.doom1_music =
{
  episode1 =
  {
    "E1M1", "E1M2", "E1M3",
    "E1M4", "E1M5", "E1M6",
    "E1M7", "E1M8", "E1M9",
  },

  episode2 =
  {
    "E2M1", "E2M2", "E2M3",
    "E2M4", "E2M5", "E2M6",
    "E2M7", "E2M9",
  },

  episode3 =
  {
    "E3M1", "E3M2", "E3M3",
    "E3M4", "E3M5", "E3M6",
    "E3M7", "E3M9",
  },
}


MUSIC_SWAP.doom2_music =
{
  episode1 =
  {
    "RUNNIN", "STALKS", "COUNTD", "BETWEE", "DOOM",
    "THE_DA", "SHAWN",  "DDTBLU", "IN_CIT", "DEAD",
  },

  episode2 =
  {
    "STLKS2", "THEDA2", "DOOM2",  "DDTBL2", "RUNNI2",
    "DEAD2",  "STLKS3", "ROMERO", "SHAWN2", "MESSAG",
  },

  episode3 =
  {
    "COUNT2", "DDTBL3", "AMPIE",  "THEDA3", "ADRIAN",
    "MESSG2", "ROMER2", "TENSE",  "SHAWN3",
  },
}


function MUSIC_SWAP.get_levels(self)
  --
  -- Note: we create the mapping (old song --> new song) here.
  --       The actual storage is done by the Boom DEHACKED code.
  --

  local text = "[MUSIC]\n"

  local epi_list = MUSIC_SWAP.doom2_music

  if OB_CONFIG.game == "doom1" or
     OB_CONFIG.game == "ultdoom"
  then
    epi_list = MUSIC_SWAP.doom1_music
  end

  for _,src in pairs(epi_list) do
    local dest = table.copy(src)

    -- this shuffle algorithm ensures first entry is never the same
    -- [ I really get sick of hearing D_RUNNIN.... ]
    for i = 1, (#dest-2) do
      local k = rand.irange(i + 1, #dest)
      dest[i], dest[k] = dest[k], dest[i]
    end

    for i = 1, #src do
      text = text .. src[i] .. " = " .. dest[i] .. "\n"
    end
  end

  GAME.music_mapping = text
end


OB_MODULES["music_swapper"] =
{
  label = _("Music Swapper"),

  side = "left",
  priority = 80,

  game = "doomish",

  engine = "boom",

  hooks =
  {
    get_levels = MUSIC_SWAP.get_levels
  },
}

