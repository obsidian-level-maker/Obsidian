------------------------------------------------------------------------
--  PANEL: Architecture
------------------------------------------------------------------------
--
--  Copyright (C) 2016-2017 Andrew Apted
--  Copyright (C) 2019 Armaetus
--  Copyright (C) 2019-2020 MsrSgtShooterPerson
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

UI_ARCH = { }

UI_ARCH.SIZES =
{
  "epi",     _("Episodic"),
  "prog",    _("Progressive"),
  "mixed",   _("Mix It Up"),

  -- this is a separator (not a usable choice)
  "_",       "_",

  "micro",    _("Microscopic"),
  "mini",     _("Miniscule"),
  "tiny",     _("Tiny"),
  "small",    _("Small"),
  "average",  _("Average"),
  "large",    _("Large"),
  "huge",     _("Huge"),
  "colossal", _("Colossal"),
  "gargan",   _("Gargantuan"),
  "trans",    _("Transcendent"),
}

UI_ARCH.ABSURDITY_CHOICES =
{
  "none", _("NONE"),
  "all",  _("Every Level"),
  "75",   _("75% of Levels"),
  "50",   _("50% of Levels"),
  "25",   _("25% of Levels"),
}

UI_ARCH.ZDOOM_VISTA_CHOICES =
{
  "enable",        _("Enable"),
  "sky_gen_smart", _("Sky-gen Smart"),
  "disable",       _("Disable"),
}

UI_ARCH.ZDOOM_SKYBOX_CHOICES =
{
  "themed",   _("Per Theme"),
  "episodic", _("Episodic"),
  "random",   _("Random"),
  "generic",  _("Generic"),
  "disable",  _("Disable"),
}

UI_ARCH.YES_NO =
{
  "yes", _("Yes"),
  "no",  _("No"),
}

UI_ARCH.PROC_GOTCHA_CHOICES =
{
  "none",  _("NONE"),
  "final", _("Final Map Only"),
  "epi",   _("Episodic (MAP11, MAP20, MAP30)"),
  "2epi",   _("2 per ep (5,11,16,20,25,30)"),
  "3epi",   _("3 per ep (3,7,11,14,17,20,23,27,30)"),
  "4epi",   _("4 per ep (3,6,9,11,14,16,18,20,23,26,28,30)"),
  "_",     _("_"),
  "5p",    _("5% Chance, Any Map After MAP04"),
  "10p",   _("10% Chance, Any Map After MAP04"),
  "all",   _("Everything"),
}

UI_ARCH.STREETS_CHOICES =
{
  "100urban", _("All Urban Maps"),
  "75urban",  _("75% of Urban Maps"),
  "50urban",  _("50% of Urban Maps"),
  "25urban",  _("25% of Urban Maps"),
  "13urban",  _("13% of Urban Maps"),
  "all",      _("All Levels"),
  "75",       _("75% of All Levels"),
  "50",       _("50% of All Levels"),
  "25",       _("25% of All Levels"),
  "13",       _("13% of All Levels"),
  "no",       _("NONE"),
}

UI_ARCH.LEVEL_PERCENTAGE_CHOICES =
{
  "all",  _("All Levels"),
  "75",   _("75% of All Levels"),
  "50",   _("50% of All Levels"),
  "25",   _("25% of All Levels"),
  "10",   _("10% of All Levels"),
  "5",    _("5% of All Levels"),
  "none", _("NONE"),
}

OB_MODULES["ui_arch"] =
{
  label = _("Architecture"),

  side = "left",
  priority = 104,

  options =
  {
    { name="size", label=_("Level Size"), choices=UI_ARCH.SIZES,  default="epi",
      tooltip = "WARNING! If you are planning to play on any choices that involve maps " ..
      "at sizes of Huge and above, Autodetail is required on. (on by default if you do not have " ..
      "Prefab Control module on. The stability of maps with sizes Colossal and beyond is not predictable.",
      gap = 1,
    },

    {
      name = "streets_mode",
      label = _("Streets Mode"),
      choices = UI_ARCH.STREETS_CHOICES,
      default = "no",
      tooltip = "Allows Oblige to create large street-like outdoor rooms.",
    },
    {
      name = "linear_mode",
      label = _("Linear Mode"),
      choices = UI_ARCH.LEVEL_PERCENTAGE_CHOICES,
      default = "none",
      tooltip = "Creates linear levels, where rooms are connected along a " ..
      "linear layout from start to exit. \n\nNote: Due to the nature of linear levels, " ..
      "you may encounter teleports even if you have teleports off. This is necessary " ..
      "in order for linear levels not to prematuraly terminate and therefore become stunted " ..
      "i.e. only have 2-5 rooms.",
    },
    {
      name = "nature_mode",
      label = _("Nature Mode"),
      choices = UI_ARCH.LEVEL_PERCENTAGE_CHOICES,
      tooltip = "Forces most of the map to be composed of naturalistic areas (parks and caves). " ..
      "The ratio is decided by Outdoors style setting while competing styles are ignored.",
      default = "10",
      gap = 1,
    },

    { name="outdoors",     label=_("Outdoors"),   choices=STYLE_CHOICES },
    { name="caves",        label=_("Caves"),      choices=STYLE_CHOICES },
    { name="liquids",      label=_("Liquids"),    choices=STYLE_CHOICES,  gap=1 },

    { name="hallways",     label=_("Hallways"),   choices=STYLE_CHOICES },
    { name="teleporters",  label=_("Teleports"),  choices=STYLE_CHOICES },
    { name="steepness",    label=_("Steepness"),  choices=STYLE_CHOICES, gap=1 },

    {
      name="prebuilt_levels",
      label=_("Prebuilt Levels"),
      choices=UI_ARCH.YES_NO,
      tooltip = "Enable or disable prebuilt maps. When disabled, are replaced with generated maps instead.",
    },
    {
      name="procedural_gotchas",
      label=_("Procedural Gotcha"),
      choices=UI_ARCH.PROC_GOTCHA_CHOICES,
      default="none",
      tooltip = "Procedural Gotchas are two room maps, where the second is an immediate " ..
      "but immensely-sized exit room with gratitiously intensified monster strength. " ..
      "Essentially an arena - prepare for a tough, tough fight!\n\nNotes:\n\n" ..
      "5% of levels may create at least 1 or 2 gotcha maps in a standard full game.",
      gap=1,
    },

    {
      name = "layout_absurdity",
      label = _("Layout Absurdity"),
      choices=UI_ARCH.ABSURDITY_CHOICES,
      default="50",
      tooltip = "The layout absurdifier attempts to cause levels to overprefer specific shape " ..
      "rules from the ruleset in order to create odd and possibly broken but interesting combinations. " ..
      "Use at your own risk. These options will affect the amount of levels have the absurdity module activated on. " ..
      "Selecting ALL will not necessarily make all levels absurd as it is all still based on chance.",
      gap=1,
    },

    {
      name = "zdoom_vista",
      label = _("Bottomless Vistas"),
      choices=UI_ARCH.ZDOOM_VISTA_CHOICES,
      default="disable",
      tooltip = "This feature allows for vistas that show more of the skybox below the horizon. " ..
      "This does not prevent skybox tiling.\n" ..
      "Enable - Bottomless vistas can always show. Pick this choice when using 3D Skyboxes.\n" ..
      "Sky-gen Smart - Bottomless vistas appear only on episodes with no mountain backdrop based on the Sky Generator.\n" ..
      "Disable - Old Oblige behavior - no bottomless vistas.",
    },
    {
      name = "zdoom_skybox",
      label = _("ZDoom 3D Skybox"),
      choices=UI_ARCH.ZDOOM_SKYBOX_CHOICES,
      default="disable",
      tooltip = "If a ZDoom based engine is selected, one has the option " ..
      "to enable a custom 3D skybox to be rendered into the map. " ..
      "It is preferable to put this on if you have ZDoom Vista enabled.",
    },
  },
}
