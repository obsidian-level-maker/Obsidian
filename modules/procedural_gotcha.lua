------------------------------------------------------------------------
--  MODULE: Procedural Gotcha Fine Tune
------------------------------------------------------------------------
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
------------------------------------------------------------------------

PROCEDURAL_GOTCHA_FINE_TUNE = {}

PROCEDURAL_GOTCHA_FINE_TUNE.GOTCHA_MAP_SIZES =
{
  "large", _("Large"),
  "regular", _("Regular"),
  "small", _("Small"),
  "tiny", _("Tiny")
}

PROCEDURAL_GOTCHA_FINE_TUNE.PROC_GOTCHA_CHOICES =
{
  "final", _("Final Map Only"),
  "epi",   _("Last Level of Episode"),
  "2epi",   _("Two per Episode"),
  "3epi",   _("Three per Episode"),
  "4epi",   _("Four per Episode"),
  "_",     _("_"),
  "5p",    _("5% Chance, Any Map After Map 4"),
  "10p",   _("10% Chance, Any Map After Map 4"),
  "all",   _("Everything")
}

function PROCEDURAL_GOTCHA_FINE_TUNE.setup(self)
  
  module_param_up(self)

end

OB_MODULES["procedural_gotcha"] =
{

  name = "procedural_gotcha",

  label = _("Procedural Gotchas"),

  engine = "!vanilla",
  engine2 = "!zdoom",
  side = "right",
  priority = 92,

  hooks =
  {
    setup = PROCEDURAL_GOTCHA_FINE_TUNE.setup
  },

  tooltip=_("This module allows you to fine tune the Procedural Gotcha experience if you have Procedural Gotchas enabled. Does not affect prebuilts. It is recommended to pick higher scales on one of the two options, but not both at once for a balanced challenge."),

  options =
  {

    {
      name="gotcha_frequency",
      label=_("Gotcha Frequency"),
      choices=PROCEDURAL_GOTCHA_FINE_TUNE.PROC_GOTCHA_CHOICES,
      default="final",
      tooltip = _("Procedural Gotchas are two room maps, where the second is an immediate but immensely-sized exit room with gratitiously intensified monster strength. Essentially an arena - prepare for a tough, tough fight!\n\nNotes:\n\n5% of levels may create at least 1 or 2 gotcha maps in a standard full game."),
      priority = 100,
      randomize_group="monsters",
    },
    

    {
      name="float_gotcha_qty",
      label=_("Extra Quantity"),
      valuator = "slider",
      units = "x Monsters",
      min = 0.2,
      max = 10,
      increment = 0.1,
      default = 1.2,
      tooltip = _("Offset monster strength from your default quantity of choice plus the increasing level ramp. If your quantity choice is to reduce the monsters, the monster quantity will cap at a minimum of 0.1 (Scarce quantity setting)."),
      randomize_group="monsters",
    },


    {
      name="float_gotcha_strength",
      label=_("Extra Strength"),
      valuator = "slider",
      min = 0,
      max = 16,
      increment = 1,
      default = 4,
      presets = _("0:NONE,2:2 (Stronger),4:4 (Harder),6:6 (Tougher),8:8 (CRAZIER),16:16 (NIGHTMARISH)"),
      tooltip = _("Offset monster quantity from your default strength of choice plus the increasing level ramp."),
      randomize_group="monsters",
    },


    {
      name="gotcha_map_size",
      label=_("Map Size"),
      choices=PROCEDURAL_GOTCHA_FINE_TUNE.GOTCHA_MAP_SIZES,
      default = "small",
      tooltip = _("Size of the procedural gotcha. Start and arena room sizes are relative to map size as well."),
      randomize_group="monsters",
    },
  },
}
