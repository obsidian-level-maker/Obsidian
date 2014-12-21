------------------------------------------------------------------------
--  PLANNING : Single Player
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2014 Andrew Apted
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


function Plan_choose_liquid()
  if THEME.liquids and STYLE.liquids != "none" then
    local name = rand.key_by_probs(THEME.liquids)
    local liquid = GAME.LIQUIDS[name]

    if not liquid then
      error("No such liquid: " .. name)
    end

    gui.printf("Liquid: %s\n\n", name)

    LEVEL.liquid = liquid

     -- setup the special '_LIQUID' material
    assert(liquid.mat)
    assert(GAME.MATERIALS[liquid.mat])

    GAME.MATERIALS["_LIQUID"] = GAME.MATERIALS[liquid.mat]

  else
    -- leave '_LIQUID' unset : it should not be used, but if does then
    -- the _ERROR texture will appear (like any other unknown material.

    gui.printf("Liquids disabled.\n\n")
  end
end



function Plan_choose_darkness()
  local prob = EPISODE.dark_prob or 0

  -- NOTE: this style is only set via the Level Control module
  if STYLE.darkness then
    prob = style_sel("darkness", 0, 10, 30, 90)
  end

  LEVEL.indoor_light = 144

  if rand.odds(prob) then
    gui.printf("Darkness falls across the land...\n\n")

    LEVEL.is_dark = true
    LEVEL.sky_bright = 0
    LEVEL.sky_shade  = 0
  else
    LEVEL.sky_bright = rand.sel(75, 192, 176)
    LEVEL.sky_shade  = LEVEL.sky_bright - 32
  end
end

