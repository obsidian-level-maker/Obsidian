------------------------------------------------------------------------
--  PANEL: Historical versions
------------------------------------------------------------------------
--
--  Copyright (C) 2016-2017 Andrew Apted
--  Copyright (C) 2019 Armaetus
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
------------------------------------------------------------------------

HISTORICAL_VERSIONS = { }

function HISTORICAL_VERSIONS.setup(self)

  module_param_up(self)

end

OB_MODULES["historical_versions"] =
{
  name = "historical_versions",

  label = _("Historical Versions"),
    
  side = "left",
  priority = 103,
  engine = "!vanilla",
  game = { chex3=0, doom1=1, doom2=1, ultdoom=1, heretic=1, hexen=0, hacx=0, harmony=0, strife=0, nukem=0, quake=0 },

  tooltip = _("Options to generate levels using past releases of Oblige, Obsidian's predecessor."),

  hooks = 
  {
    setup = HISTORICAL_VERSIONS.setup,
  },

  options =
  {

    {
      name = "float_historical_oblige_v2",
      label = _("Oblige v2"),
      valuator = "slider",
      units = "% of Levels",
      min = 0,
      max = 100,
      increment = 1,
      default = 0,
      tooltip = _("Sets chance of levels being generated using Oblige v2"),
      longtip = _("Gives levels a chance of being generated using an internal version of Oblige version 2.x. NOTE: Not all module settings will affect levels generated in this manner."),
      priority = 102,
      randomize_group = "architecture",
    },
    
  },
}
