----------------------------------------------------------------
--  MODULE: id software mode
----------------------------------------------------------------
--  Copyright (C) 2021 Armaetus
--  Copyright (C) 2021 dasho
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
----------------------------------------------------------------

-- This is to mimic general features seen in the Doom games. Only
-- Doom 2 has been fully analyzed (pending tweaks if needed) so
-- Doom 2 will be the one working right now.

-- Possible choices for configuration:
--
-- Size, monster quantity, lighting level, amount of outdoors, secret quantity,
-- teleporters, traps, windows, steepness, street mode, procedural gotcha,
-- room height size, cages, sink type, liquids, barrels, keyed doors, normal doors,
-- nearby and distant/remote switches, fences, porches, big rooms/outdoors, ambushes,
-- scenics, symmetry, parks/park detail, caves, hallways, etc.

IWAD_MODE = { }

-- Needs the following:
-- Checks for monster quantity, room height bias, procedural gotcha,
-- streets mode, brightness offset, sink style, switch goals/remote switch choices,
-- cliffs and more.

------------
-- Doom 2 --
------------

IWAD_MODE.styles = {
  -- Approximate map dimensions: 3,500 x 3,600 map units
  MAP01 = {
    outdoors = "few", -- just outdoor secret and overlook
    caves = "none",
    parks = "none",
    liquids = "none",
    hallways = "few",
    big_rooms = "none",
    big_outdoor_rooms = "none",
    teleporters = "none",
    steepness = "few",
    traps = "none",
    cages = "few",
    ambushes = "few",
    doors = "few", -- side room and exit doors
    windows = "few", -- one window
    switches = "none", -- secret switch doesn't count
    keys = "none",
    trikeys= "none",
    scenics = "few",
    secrets = "few", -- shotgun secret
    parks = "none", -- nope!
    park_detail = "none",
    symmetry = "none",
    pictures = "some",
    barrels = "none",
    beams = "few",
    porches = "some",
    fences = "none"
  },

  MAP02 =
  {
    liquids = "heaps", -- everywhere!
    outdoors = "none", -- indoor map
    parks = "none",
    park_detail = "none",
    hallways = "few",
    big_rooms = "none",
    big_outdoor_rooms = "none",
    steepness = "few",
    traps = "some",
    windows = "none", -- map is indoors
    teleporters = "few", -- just that one by red key..
    keys = "few", -- single red door
    trikeys = "none",
    switches = "few",
    barrels = "some", -- lower rooms have them
    porches = "none",
    cages = "none",
    fences = "none",
    scenics = "none",
    pictures = "some",
    symmetry = "none",
    beams = "none "
  }
}

--[[ MAP03 Approximate map dimensions: 3,000 x 2,000 map units
IWAD_MODE.doom2_MAP03 =
{

}

-- MAP04 Approximate map dimensions: 2,000 x 1,650 map units
IWAD_MODE.doom2_MAP04 =
{

}

-- MAP05 Approximate map dimensions: 3,150 x 2,150 map units
IWAD_MODE.doom2_MAP05 =
{

}

-- MAP06 Approximate map dimensions: 4,000 x 2,500 map units
IWAD_MODE.doom2_MAP06 =
{

}
-- MAP07 Approximate map dimensions: 2,300 x 2,000 map units
IWAD_MODE.doom2_MAP07 =
{

}

-- MAP08 Approximate map dimensions: 4,000 x 4,000 map units
IWAD_MODE.doom2_MAP08 =
{

}

-- MAP09 Approximate map dimensions: 4,200 x 4,000 map units
IWAD_MODE.doom2_MAP09 =
{

}

-- MAP10 Approximate map dimensions: 4,200 x 4,200 map units
IWAD_MODE.doom2_MAP10 =
{

}

-- MAP11 Approximate map dimensions: 3,600 x 29000 map units
IWAD_MODE.doom2_MAP11 =
{

}

-- MAP12 Approximate map dimensions: 4,000 x 4,400 map units
IWAD_MODE.doom2_MAP12 =
{

}

-- MAP13 Approximate map dimensions: 3,200 x 4,100 map units
IWAD_MODE.doom2_MAP13 =
{

}

-- MAP14 Approximate map dimensions: 3,900 x 3,600 map units
IWAD_MODE.doom2_MAP14 =
{

}

-- MAP15 Approximate map dimensions: 4,300 x 7,200 map units
IWAD_MODE.doom2_MAP15 =
{

}

-- MAP16 Approximate map dimensions: 4,900 x 4,800 map units
IWAD_MODE.doom2_MAP16 =
{

}

-- MAP17 Approximate map dimensions: 3,300 x 3,300 map units
IWAD_MODE.doom2_MAP17 =
{

}

-- MAP18 Approximate map dimensions: 4,900 x 4,500 map units
IWAD_MODE.doom2_MAP18 =
{

}

-- MAP19 Approximate map dimensions: 5,550 x 6,000 map units
IWAD_MODE.doom2_MAP19 =
{

}

-- MAP20 Approximate map dimensions: 5,200 x 6,300 map units
IWAD_MODE.doom2_MAP20 =
{

}

-- MAP21 Approximate map dimensions: 3,500 x 3,000 map units
IWAD_MODE.doom2_MAP21 =
{

}

-- MAP22 Approximate map dimensions: 2,300 x 1,850 map units
IWAD_MODE.doom2_MAP22 =
{

}

-- MAP23 Approximate map dimensions: 4,300 x 5,050 map units
IWAD_MODE.doom2_MAP23 =
{

}

-- MAP24 Approximate map dimensions: 6,000 x 5,300 map units
IWAD_MODE.doom2_MAP24 =
{

}

-- MAP25 Approximate map dimensions: 3,600 x 7,200 map units
IWAD_MODE.doom2_MAP25 =
{

}

-- MAP26 Approximate map dimensions: 4,600 x 3,200 map units
IWAD_MODE.doom2_MAP26 =
{

}

-- MAP27 Approximate map dimensions: 3,900 x 4,500 map units
IWAD_MODE.doom2_MAP27 =
{

}

-- MAP28 Approximate map dimensions: 4,400 x 5,000 map units
IWAD_MODE.doom2_MAP28 =
{

}

-- MAP29 Approximate map dimensions: 4,800 x 4,600 map units
IWAD_MODE.doom2_MAP29 =
{

}

-- MAP30 Approximate map dimensions: 2,750 x 2,800 map units
IWAD_MODE.doom2_MAP30 =
{

}

-- MAP31 Approximate map dimensions: 8,750 x 7,200 map units
IWAD_MODE.doom2_MAP31 =
{

}

-- MAP32 Approximate map dimensions: 4,000 x 7,200 map units
IWAD_MODE.doom2_MAP31 =
{

}

------------------------
-- Doom/Ultimate Doom --
------------------------

-- E1M1 Approximate map dimensions: 4,600 x 2,800 nap units
IWAD_MODE.doom_E1M1 =
{

}

-- E1M2 Approximate map dimensions: 5,300 x 3,900 nap units
IWAD_MODE.doom_E1M2 =
{

}

-- E1M3 Approximate map dimensions: 4,100 x 3,050 map units
IWAD_MODE.doom_E1M3 =
{

}

-- E1M4 Approximate map dimensions: 3,700 x 2,800 map units
IWAD_MODE.doom_E1M4 =
{

}

-- E1M5 Approximate map dimensions: 4,000 x 3,200 map units
IWAD_MODE.doom_E1M5 =
{

}

-- E1M6 Approximate map dimensions: 5,800 x 4,900 map units
IWAD_MODE.doom_E1M6 =
{

}

-- E1M7 Approximate map dimensions: 4,000 x 3,400 map units
IWAD_MODE.doom_E1M7 =
{

}

-- E1M8 Approximate map dimensions: 6,600 x 7,100 map units
IWAD_MODE.doom_E1M8 =
{

}

-- E1M9 Approximate map dimensions: 3,400 x 3,200 map units
IWAD_MODE.doom_E1M9 =
{

}]]

-- translate changes to here instead
function IWAD_MODE.begin_level()

  local nt = assert(namelib.NAMES)

  if LEVEL.name == "MAP01" then
    LEVEL.map_W = 18
    LEVEL.description = rand.key_by_probs(nt.TECH.lexicon.b) .. " Entryway"
  elseif LEVEL.name == "MAP02" then
    LEVEL.map_W = 22
  end

  -- combine explicit tables from above
  if IWAD_MODE.styles[LEVEL.name] then
    table.merge(STYLE, IWAD_MODE.styles[LEVEL.name])
  end

  LEVEL.map_H = LEVEL.map_W

  -- reporting changes
  gui.printf(table.tostr(LEVEL,2))
end

-- TODO: E1M1 through E4M9

--[[function IWAD_MODE.iwad_style_levels(self)

  for _,LEV in pairs(GAME.levels) do
    if LEV.name == "MAP01" then
      LEV.custom_size = 18
    end

    if LEV.name == "MAP02" then
      LEV.custom_size = 22
    end

    if LEV.name == "MAP03" then
      LEV.custom_size = 25
    end

    if LEV.name == "MAP04" then
      LEV.custom_size = 20
    end

    if LEV.name == "MAP05" then
        LEV.custom_size = 24
    end

    if LEV.name == "MAP06" then
      LEV.custom_size = 28
    end

    if LEV.name == "MAP07" then
      LEV.custom_size = 20
      LEV.is_procedural_gotcha = true
    end

    if LEV.name == "MAP08" then
      LEV.custom_size = 24
    end

    if LEV.name == "MAP09" then
      LEV.custom_size = 28
    end

    if LEV.name == "MAP10" then
      LEV.custom_size = 34
    end

    if LEV.name == "MAP11" then
      LEV.custom_size = 24
    end

    if LEV.name == "MAP12" then
      LEV.custom_size = 24
    end

    if LEV.name == "MAP13" then
      LEV.custom_size = 36
      LEV.has_streets = true
    end

    if LEV.name == "MAP14" then
      LEV.custom_size = 26
    end

    if LEV.name == "MAP15" then
      LEV.custom_size = 34
    end

    if LEV.name == "MAP16" then
      LEV.custom_size = 30
      LEV.has_streets = true
    end
  end
end

function IWAD_MODE.iwad_style_styles(self, local_table, qualifier)

  for tablename, tablebody in pairs(IWAD_MODE) do
    if OB_CONFIG.game == string.match(tablename, "%w*") then
      if qualifier == string.match(tablename, "MAP%d%d") or LEVEL.name == string.match(tablename, "E%dM%d") then
        table.merge(local_table, tablebody)
      end
    end
  end

end]]


OB_MODULES["iwad_mode"] =
{
  label = _("(Exp) IWAD Style Mode"),
  engine = "!vanilla",
  game = "doom2", -- Only one supported for now
  side = "left",
  priority = 60,
  tooltip ="Attempts to mimic various architectural features seen in the Doom IWAD maps.",

  hooks =
  {
    --get_levels = IWAD_MODE.iwad_style_levels,
    begin_level = IWAD_MODE.begin_level
  }
}