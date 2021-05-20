----------------------------------------------------------------
--  MODULE: id software mode
----------------------------------------------------------------
--  Copyright (C) 2021 Armaetus
--  Copyright (C) 2021 dasho
--  Copyrighr (C) 2021 MsrSgtShooterPerson
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

-- LEVEL.size_multiplier
-- LEVEL.area_multiplier
-- LEVEL.size_consistency = strict/normal
-- PARAM.brightness_offset

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
    liquids = "few", -- outdoor secret
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
    windows = "few", -- map is indoors
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
    beams = "none",
    caves = "none"
  },

  -- MAP03 Approximate map dimensions: 3,000 x 2,000 map units
  MAP03 =
  {
    outdoors = "some",
    liquids = "some", -- pools around main room outside
    parks = "none",
    park_detail = "none",
    big_rooms = "some",
    big_outdoor_rooms = "few",
    traps = "few",
    keys = "few",
    trikeys = "none",
    cages = "few",
    barrels = "none",
    switches = "few",
    scenics = "few",
    windows = "some",
    fences = "none",
    symmetry = "none",
    porches = "few",
    teleporters = "few",
    steepness = "some",
    doors = "few",
    caves = "none",
    pictures = "few"
  },

  -- MAP04 Approximate map dimensions: 2,000 x 1,650 map units
  MAP04 =
  {
    outdoors ="none", -- totally indoors!
    big_outdoor_rooms = "none", -- again, inside
    big_rooms = "none", -- small, cramped rooms
    barrels = "some",
    keys = "heaps", -- three keys in map
    trikeys = "none",
    cages = "none",
    teleporters = "few",
    switches = "few",
    windows = "few",
    parks = "none",
    park_detail = "none",
    liquids = "few", -- just that slime pool leading to SSG secret
    traps = "some",
    symmetry = "none",
    steepness = "few",
    secrets = "few",
    porches = "none",
    caves = "none",
    pictures = "heaps"
  },

  -- MAP05 Approximate map dimensions: 3,150 x 2,150 map units
  MAP05 =
  {
    outdoors = "some", -- courtyard
    big_outdoor_areas = "few",
    parks = "few",
    steepness = "heaps",
    doors = "some",
    keys = "some",
    trikeys = "none",
    teleporters = "few",
    ambushes = "heaps", -- lots of them near start
    traps = "some",
    liquids = "some",
    barrels = "none",
    secrets = "few",
    hallways = "some",
    porches = "heaps",
    switches = "few",
    caves = "few",
    pictures = "few"
  },

  -- MAP06 Approximate map dimensions: 4,000 x 2,500 map units
  MAP06 =
  {
    outdoors = "few", -- outdoor lava courtyard
    liquids = "some",
    big_rooms = "some", -- Mastermind crusher room
    big_outdoor_rooms = "none",
    barrels = "few", -- megasphere room only
    keys = "some",
    trikeys ="few", -- sure, why not?
    ambushes = "some",
    traps = "heaps",
    steepness = "heaps",
    windows = "none",
    hallways = "few",
    symmetry = "none",
    teleporters = "few",
    cages = "some",
    porches = "few",
    switches = "some",
    caves = "none",
    pictures = "some"
  },

  -- MAP07 Approximate map dimensions: 2,300 x 2,000 map units
  MAP07 =
  {
    symmetry = "heaps", -- map is completely symmetrical
    outdoors = "heaps", -- lots of outdoors
    big_outdoor_rooms = "some",
    parks = "none",
    park_detail = "none",
    ambushes = "some",
    beams = "heaps",
    traps = "heaps",
    teleporters ="none",
    porches = "few",
    liquids = "none",
    cages = "none",
    steepness = "few", -- one of the few Doom 2 maps with very little height variation
    hallways = "none",
    barrels = "none",
    windows = "few",
    doors = "few",
    keys = "few",
    trikeys = "none",
    switches = "some",
    caves = "none",
    pictures = "few"
  },

  -- MAP08 Approximate map dimensions: 4,000 x 4,000 map units
  MAP08 =
  {
    outdoors = "none", -- another totally indoor map..
    windows = "none",
    big_outdoor_rooms = "none",
    traps = "heaps", -- not called "Tricks and Traps" for nothing!
    ambushes = "heaps",
    steepness = "some",
    barrels = "none",
    hallways = "some",
    keys = "some",
    trikeys = "few",
    switches = "some",
    teleporters = "some",
    symmetry = "none",
    doors = "some",
    porches = "none",
    beams = "some",
    caves = "none",
    pictures = "heaps"
  },

  -- MAP09 Approximate map dimensions: 4,200 x 4,000 map units
  MAP09 =
  {
    steepness = "heaps",
    outdoors = "few",
    big_outdoor_rooms = "some",
    symmetry = "none",
    doors = "some",
    keys ="heaps",
    trikeys = "some",
    porches = "few",
    teleporters ="few",
    traps = "some",
    switches = "some",
    beams = "few",
    ambushes = "heaps",
    traps = "few",
    pictures = "some",
    barrels = "none",
    liquids = "few",
    parks = "none",
    cages = "heaps",
    secrets = "few",
    hallways = "some",
    windows = "few",
    scenics = "none"
  },

  -- MAP10 Approximate map dimensions: 4,200 x 4,200 map units
  MAP10 =
  {
    big_rooms = "heaps",
    big_outdoor_rooms = "few",
    caves = "few",
    doors = "some",
    keys = "heaps",
    trikeys = "few",
    switches = "few",
    barrels = "some",
    outdoors = "none",
    steepness = "few",
    fences = "none",
    liquids = "none",
    ambushes = "some",
    traps = "some",
    hallways = "few",
    windows = "few",
    beams = "some",
    scenics = "few"
  },

  -- MAP11 Approximate map dimensions: 3,600 x 29000 map units
  MAP11 =
  {
    outdoors = "heaps", -- It *is* outside mostly..
    big_outdoor_rooms = "heaps",
    big_rooms = "some",
    steepness = "heaps",
    windows = "some",
    doors = "few",
    keys = "some",
    trikeys = "few",
    caves = "some",
    ambushes = "some",
    traps = "some",
    beams = "heaps",
    switches = "few",
    teleporters = "some",
    secrets = "some",
    liquids = "heaps",
    cages = "some",
    scenics = "some",
    parks = "few",
    symmetry = "none"
  },

  -- MAP12 Approximate map dimensions: 4,000 x 4,400 map units
  MAP12 =
  {
    outdoors = "heaps",
    big_outdoor_rooms = "heaps",
    big_rooms = "few",
    windows = "few",
    scenics = "heaps",
    steepness = "some",
    parks = "some",
    park_detail = "few",
    ambushes = "few",
    traps = "some",
    keys = "some",
    trikeys = "few",
    switches = "some",
    liquids = "none",
    teleporters = "few",
    secrets = "few",
    doors = "some",
    beams = "none",
    symmetry = "some",
    cages = "few",
    pictures = "some",
    barrels = "none"
  },

  -- MAP13 Approximate map dimensions: 3,200 x 4,100 map units
  MAP13 =
  {
    outdoors = "heaps",
    big_outdoor_rooms = "some",
    doors = "heaps",
    big_rooms = "some",
    windows = "heaps",
    ambushes = "some",
    traps = "some",
    keys = "heaps",
    trikeys = "some",
    switches = "some",
    steepness = "heaps",
    barrels = "few",
    teleporters = "some",
    secrets = "some",
    symmetry = "heaps",
    cages = "heaps",
    pictures = "some",
    liquids = "none",
    caves = "none",
    scenics = "some",
    fences = "few",
    porches = "some",
    hallways = "few"
  },

  -- MAP14 Approximate map dimensions: 3,900 x 3,600 map units
  MAP14 =
  {
    outdoors = "some",
    big_outdoor_rooms = "few",
    big_rooms = "some",
    steepness = "some",
    windows = "heaps",
    ambushes = "some",
    traps = "some",
    barrels = "none",
    teleporters = "few",
    scenics = "some",
    fences = "heaps",
    porches = "heaps",
    liquids = "some",
    keys = "heaps",
    trikeys = "none",
    symmetry = "heaps",
    secrets = "few",
    hallways = "none",
    parks = "few",
    park_detail = "some"
  },

  -- MAP15 Approximate map dimensions: 4,300 x 7,200 map units
  MAP15 =
  {
    outdoors = "heaps",
    big_outdoor_rooms = "heaps",
    windows = "some",
    steepness = "heaps",
    barrels = "some",
    ambushes = "some",
    traps = "few",
    secrets = "heaps",
    porches = "heaps",
    teleporters = "some",
    liquids = "some",
    keys = "some",
    trikeys = "none",
    hallways = "none",
    scenics = "some",
    symmetry = "heaps",
    fences = "heaps",
    parks = "none",
    hallways = "few",
    switches = "some",
    pictures = "heaps",
    cages = "some"
  },

  -- MAP16 Approximate map dimensions: 4,900 x 4,800 map units
  MAP16 =
  {
    outdoors = "heaps",
    big_outdoor_rooms = "heaps",
    windows = "heaps",
    big_rooms = "none",
    steepness = "some",
    switches = "few",
    keys = "some",
    trikeys = "some",
    liquids = "few",
    pictures = "heaps",
    hallways = "few",
    fences = "some",
    scenics = "heaps",
    symmetry = "some",
    ambushes = "some",
    traps = "heaps",
    secrets = "few",
    barrels = "none",
    beams = "some",
    cages = "few"
  }
}

--[[ MAP17 Approximate map dimensions: 3,300 x 3,300 map units
MAP17 =
{

}

-- MAP18 Approximate map dimensions: 4,900 x 4,500 map units
MAP18 =
{

}

-- MAP19 Approximate map dimensions: 5,550 x 6,000 map units
MAP19 =
{

}

-- MAP20 Approximate map dimensions: 5,200 x 6,300 map units
MAP20 =
{

}

-- MAP21 Approximate map dimensions: 3,500 x 3,000 map units
MAP21 =
{

}

-- MAP22 Approximate map dimensions: 2,300 x 1,850 map units
MAP22 =
{

}

-- MAP23 Approximate map dimensions: 4,300 x 5,050 map units
MAP23 =
{

}

-- MAP24 Approximate map dimensions: 6,000 x 5,300 map units
MAP24 =
{

}

-- MAP25 Approximate map dimensions: 3,600 x 7,200 map units
MAP25 =
{

}

-- MAP26 Approximate map dimensions: 4,600 x 3,200 map units
MAP26 =
{

}

-- MAP27 Approximate map dimensions: 3,900 x 4,500 map units
MAP27 =
{

}

-- MAP28 Approximate map dimensions: 4,400 x 5,000 map units
MAP28 =
{

}

-- MAP29 Approximate map dimensions: 4,800 x 4,600 map units
MAP29 =
{

}

-- MAP30 Approximate map dimensions: 2,750 x 2,800 map units
MAP30 =
{

}

-- MAP31 Approximate map dimensions: 8,750 x 7,200 map units
MAP31 =
{

}

-- MAP32 Approximate map dimensions: 4,000 x 7,200 map units
MAP32 =
{

}

------------------------
-- Doom/Ultimate Doom --
------------------------

-- E1M1 Approximate map dimensions: 4,600 x 2,800 nap units
E1M1 =
{

}

-- E1M2 Approximate map dimensions: 5,300 x 3,900 nap units
E1M2 =
{

}

-- E1M3 Approximate map dimensions: 4,100 x 3,050 map units
E1M3 =
{

}

-- E1M4 Approximate map dimensions: 3,700 x 2,800 map units
E1M4 =
{

}

-- E1M5 Approximate map dimensions: 4,000 x 3,200 map units
E1M5 =
{

}

-- E1M6 Approximate map dimensions: 5,800 x 4,900 map units
E1M6 =
{

}

-- E1M7 Approximate map dimensions: 4,000 x 3,400 map units
E1M7 =
{

}

-- E1M8 Approximate map dimensions: 6,600 x 7,100 map units
E1M8 =
{

}

-- E1M9 Approximate map dimensions: 3,400 x 3,200 map units
E1M9 =
{

}]]

-- translate changes to here instead
function IWAD_MODE.begin_level()

  local nt = assert(namelib.NAMES)

  if LEVEL.name == "MAP01" then
    LEVEL.map_W = 18
    LEVEL.description = rand.key_by_probs(nt.TECH.lexicon.b) .. " Entryway"
    LEVEL.size_multiplier = 0.6
    LEVEL.size_consistency = strict
  elseif LEVEL.name == "MAP02" then
    LEVEL.map_W = 22
    LEVEL.size_multiplier = 0.5
    LEVEL.size_consistency = strict
  elseif LEVEL.name == "MAP03" then
    LEVEL.map_W = 25
    LEVEL.size_multiplier = 0.75
  elseif LEVEL.name == "MAP04" then
    LEVEL.map_W = 20
    LEVEL.size_multiplier = 0.6
    LEVEL.size_consistency = strict
  elseif LEVEL.name == "MAP05" then
    LEVEL.map_W = 28
    LEVEL.size_multiplier = 0.8
  elseif LEVEL.name == "MAP06" then
    LEVEL.map_W = 30
    LEVEL.size_multiplier = 0.7
  elseif LEVEL.name == "MAP07" then -- Procedural Gotcha
    LEVEL.map_W = 20
    LEVEL.size_consistency = strict
    LEVEL.description = rand.key_by_probs(nt.TECH.lexicon.b) .. " Simple"
    LEVEL.size_multiplier = 1.2
  elseif LEVEL.name == "MAP08" then
    LEVEL.map_W = 28
    LEVEL.size_multiplier = 0.8
    LEVEL.description = rand.key_by_probs(nt.TECH.lexicon.b) .. " and Traps"
  elseif LEVEL.name == "MAP09" then
    LEVEL.map_W = 26
    LEVEL.size_multiplier = 0.7
  elseif LEVEL.name == "MAP10" then
    LEVEL.map_W = 32
    LEVEL.size_multiplier = 1.2
  elseif LEVEL.name == "MAP11" then
    LEVEL.map_W = 26
    LEVEL.size_multiplier = 0.8
  elseif LEVEL.name == "MAP12" then
    LEVEL.map_W = 28
    LEVEL.size_consistency = strict
    LEVEL.size_multiplier = 0.75
  elseif LEVEL.name == "MAP13" then -- Streets mode
    LEVEL.map_W = 34
    LEVEL.size_multiplier = 0.7
    LEVEL.description = rand.key_by_probs(nt.URBAN.lexicon.b) .. " Downtown"
  elseif LEVEL.name == "MAP14" then
    LEVEL.map_W = 24
    LEVEL.size_multiplier = 0.5
    LEVEL.size_consistency = strict
  elseif LEVEL.name == "MAP15" then
    LEVEL.map_W = 36
    LEVEL.size_multiplier = 0.8
    LEVEL.description = rand.key_by_probs(nt.URBAN.lexicon.b) .. " Industrial"
  elseif LEVEL.name == "MAP16" then -- Streets mode
    LEVEL.map_W = 30
    LEVEL.size_multiplier = 1.2
  elseif LEVEL.name == "MAP17" then
    LEVEL.map_W = 26
    LEVEL.size_multiplier = 0.65
  elseif LEVEL.name == "MAP18" then
    LEVEL.map_W = 24
    LEVEL.size_multiplier = 0.7
    LEVEL.size_consistency = strict
  elseif LEVEL.name == "MAP19" then
    LEVEL.map_W = 34
    LEVEL.size_multiplier = 0.7
    LEVEL.description = rand.key_by_probs(nt.URBAN.lexicon.b) .. " Citadel"
  elseif LEVEL.name == "MAP20" then
    LEVEL.map_W = 36
    LEVEL.size_multiplier = 0.9
  elseif LEVEL.name == "MAP21" then
    LEVEL.map_W = 20
    LEVEL.size_multiplier = 0.5
    LEVEL.size_consistency = strict
    LEVEL.description = rand.key_by_probs(nt.HELL.lexicon.b) .. " Nirvana"
  elseif LEVEL.name == "MAP22" then
    LEVEL.map_W = 22
    LEVEL.size_multiplier = 0.5
    LEVEL.size_consistency = strict
  elseif LEVEL.name == "MAP23" then
    LEVEL.map_W = 26
    LEVEL.size_multiplier = 0.7
    LEVEL.description = rand.key_by_probs(nt.HELL.lexicon.b) .. " Barrels"
  elseif LEVEL.name == "MAP24" then
    LEVEL.map_W = 30
    LEVEL.size_multiplier = 0.8
    LEVEL.description = rand.key_by_probs(nt.HELL.lexicon.b) .. " Chasm"
  elseif LEVEL.name == "MAP25" then
    LEVEL.map_W = 26
    LEVEL.size_multiplier = 0.6
  elseif LEVEL.name == "MAP26" then
    LEVEL.map_W = 30
    LEVEL.size_multiplier = 0.8
  elseif LEVEL.name == "MAP27" then
    LEVEL.map_W = 24
    LEVEL.size_multiplier = 0.6
    LEVEL.size_consistency = strict
  elseif LEVEL.name == "MAP28" then
    LEVEL.map_W = 28
    LEVEL.size_multiplier = 0.9
  elseif LEVEL.name == "MAP29" then
    LEVEL.map_W = 32
    LEVEL.size_multiplier = 0.8
    LEVEL.description = rand.key_by_probs(nt.HELL.lexicon.b) .. " End"
  elseif LEVEL.name == "MAP30" then -- Procedural Gotcha
    LEVEL.map_W = 36
    LEVEL.size_multiplier = 2.0
    LEVEL.size_consistency = strict
    LEVEL.description = rand.key_by_probs(nt.HELL.lexicon.b) .. " Icon"
  elseif LEVEL.name == "MAP31" then
    LEVEL.map_W = 28
    LEVEL.size_multiplier = 0.7
    LEVEL.size_consistency = strict
  elseif LEVEL.name == "MAP32" then
    LEVEL.map_W = 24
    LEVEL.size_multiplier = 0.6
    LEVEL.size_consistency = strict
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