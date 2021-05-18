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

-- Approximate map dimensions: 3,500 x 3,600 map units
IWAD_MODE.doom2_MAP01 =
                {
                    outdoors = { few=100 }, -- just outdoor secret and overlook
                    caves = { none=100 },
                    parks = { none=100 },
                    liquids = { none=100 },
                    hallways = { few=100 },
                    big_rooms = { none=100 },
                    big_outdoor_rooms = { none=100 },
                    teleporters = { none=100 },
                    steepness = { few=100 },
                    traps = { none=100 },
                    cages = { few=100 },
                    ambushes = { few=100 },
                    doors = { few=100 }, -- side room and exit doors
                    windows = { few=100 }, -- one window
                    switches = { none=100 }, -- secret switch doesn't count
                    keys = { none=100 },
                    trikeys= { none=100 },
                    scenics = { some=100 }, -- shotgun secret
                    parks = { none=100 }, -- nope!
                    park_detail = { none=100 },
                    symmetry = { none=100 },
                    pictures = { some=100 },
                    barrels = { none=100 },
                    beams = { few=100 },
                    porches = { some=100 }, -- chainsaw porch!
                    fences = { none=100 }
                }


-- Approximate map dimensions: 2,000 x 1,900 map units
IWAD_MODE.doom2_MAP02 =
                {
                    liquids = { heaps=100 }, -- everywhere!
                    outdoors = { none=100 }, -- indoor map
                    parks = { none=100 },
                    park_detail = { none=100 },
                    hallways = { few=100 },
                    big_rooms = { none=100 },
                    big_outdoor_rooms = { none=100 },
                    steepness = { few=100 },
                    traps = { some=100 },
                    windows = { none=100 }, -- map is indoors
                    teleporters = { few=100 }, -- just that one by red key..
                    keys = { few=100 }, -- single red door
                    trikeys = { none=100 },
                    switches = { few=100 },
                    barrels = { some=100 }, -- lower rooms have them
                    porches = { none=100 },
                    cages = { none=100 },
                    fences = { none=100 },
                    scenics = { none=100 },
                    pictures = { some=100 },
                    symmetry = { none=100 },
                    beams = { none=100 }
                }

-- MAP03 Approximate map dimensions: 3,000 x 2,000 map units
-- MAP04 Approximate map dimensions: 2,000 x 1,650 map units
-- MAP05 Approximate map dimensions: 3,150 x 2,150 map units
-- MAP06 Approximate map dimensions: 4,000 x 2,500 map units
-- MAP07 Approximate map dimensions: 2,300 x 2,000 map units
-- MAP08 Approximate map dimensions: 4,000 x 4,000 map units
-- MAP09 Approximate map dimensions: 4,200 x 4,000 map units
-- MAP10 Approximate map dimensions: 4,200 x 4,200 map units
-- MAP11 Approximate map dimensions: 3,600 x 29000 map units
-- MAP12 Approximate map dimensions: 4,000 x 4,400 map units
-- MAP13 Approximate map dimensions: 3,200 x 4,100 map units

-- TODO: MAP03 - MAP32 and E1M1 through E4M9
              
function IWAD_MODE.iwad_style_levels(self)

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
            LEV.custom_size = 20 -- This needs to be a Procedural Gotcha..
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
            LEV.has_streets = true -- Must be Streets mode
        end

        if LEV.name == "MAP14" then
            LEV.custom_size = 26
        end

        if LEV.name == "MAP15" then
            LEV.custom_size = 34
        end

        if LEV.name == "MAP16" then
            LEV.custom_size = 30 -- Must be Streets mode
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
  
end

OB_MODULES["iwad_mode"] =
{
label = _("(Exp) IWAD Style Mode"),
engine = "!vanilla",
game = "doom2", -- Only one supported for now
side = "left",
priority = 60,
tooltip ="Attempts to mimic various architectural features seen in the Doom IWAD maps.",

tables =
{
    IWAD_MODE
},

hooks =
{
    get_levels = IWAD_MODE.iwad_style_levels,
    override_level_style = IWAD_MODE.iwad_style_styles
}
}
