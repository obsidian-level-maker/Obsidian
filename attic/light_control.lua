----------------------------------------------------------------
--  MODULE: Lighting Control
----------------------------------------------------------------
--
--  Copyright (C) 2010 Andrew Apted
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
----------------------------------------------------------------

-- NOTE: this might be better done as an Option in the GUI


function LightControl_setup(self)
  local value = self.options.precision.value

  if GAME.format == "quake" or GAME.format == "quake2" then
    gui.property("lighting_quality", value)
  else
    GAME.lighting_precision = self.options.precision.value
  end
end


UNFINISHED["light_control"] =
{
  label = "Lighting Control",

  for_games = { doom1=1, doom2=1, heretic=1, hexen=1, strife=1,
                quake=1, quake2=1, hexen2=1, halflife=1
              },

  hooks =
  {
    setup = LightControl_setup,
  },

  options =
  {
    quality =
    {
      label = "Quality",

      choices =
      {
        "low",  "Low \\/ Fast",
        "medium", "Medium",
        "high", "High \\/ Slow",
      },

      default = "high",
    },
  }
}

