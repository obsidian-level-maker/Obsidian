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

UI_ARCH.ZDOOM_VISTA_CHOICES =
{
  "enable",        _("Enable"),
  "sky_gen_smart", _("Sky-gen Smart"),
  "disable",       _("Disable")
}

UI_ARCH.ZDOOM_SKYBOX_CHOICES =
{
  "themed",   _("Per Theme"),
  "episodic", _("Episodic"),
  "random",   _("Random"),
  "generic",  _("Generic"),
  "disable",  _("Disable")
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
  "all",   _("Everything")
}

function UI_ARCH.setup(self)
  -- these parameters have to be instantiated in this hook
  -- because begin_level happens *after* level size decisions
  for _,opt in pairs(self.options) do
    if opt.valuator then
      if opt.valuator == "button" then
        PARAM[opt.name] = gui.get_module_button_value(self.name, opt.name)
      elseif opt.valuator == "slider" then
        PARAM[opt.name] = gui.get_module_slider_value(self.name, opt.name)      
      end
    end
  end
end

OB_MODULES["ui_arch"] =
{

  name = "ui_arch",

  label = _("Architecture"),

  side = "left",
  priority = 104,
  engine = "!vanilla",

  hooks = 
  {
    setup = UI_ARCH.setup,
  },

  options =
  {
    { 
      name="float_size", 
      label=_("Level Size"),
      valuator = "slider",
      units = "",
      min = 7,
      max = 75,
      increment = 1,
      default = 7,
      nan= "7:Mix It Up," ..
      "8:Episodic," ..
      "9:Progressive," ..
      "10:10 (Microscopic)," ..
      "16:16 (Miniature)," ..
      "22:22 (Tiny)," ..
      "30:30 (Small)," ..
      "36:36 (Average)," ..
      "42:42 (Large)," ..
      "48:48 (Huge)," ..
      "58:58 (Colossal)," ..
      "66:66 (Gargantuan)," ..
      "75:75 (Transcendent),",
      tooltip = "WARNING! If you are planning to play on any choices that involve maps " ..
      "at sizes of 50 and above, Autodetail is required on. (on by default if you do not have " ..
      "Prefab Control module on. The stability of maps with sizes 60 and beyond is not predictable.",
      gap = 1
    },

    {
      name = "float_linear_mode",
      label = _("Linear Mode"),
      valuator = "slider",
      units = "% of Levels",
      min = 0,
      max = 100,
      increment = 1,
      default = 0,
      nan = "",
      tooltip = "Creates linear levels, where rooms are connected along a " ..
      "linear layout from start to exit. \n\nNote: Due to the nature of linear levels, " ..
      "you may encounter teleports even if you have teleports off. This is necessary " ..
      "in order for linear levels not to prematuraly terminate and therefore become stunted " ..
      "i.e. only have 2-5 rooms."
    },

    {
      name = "float_nature_mode",
      label = _("Nature Mode"),
      valuator = "slider",
      units = "% of Levels",
      min = 0,
      max = 100,
      increment = 1,
      default = 0,
      nan = "",
      tooltip = "Forces most of the map to be composed of naturalistic areas (parks and caves). " ..
      "The ratio is decided by Outdoors style setting while competing styles are ignored.",
    },

    {
      name = "float_streets_mode",
      label = _("Streets Mode"),
      valuator = "slider",
      units = "% of Levels",
      min = 0,
      max = 100,
      increment = 1,
      default = 15,
      nan = "",
      tooltip = "Allows Oblige to create large street-like outdoor rooms.",
    },

    {
      name = "bool_urban_streets_mode",
      label=_("Urban Only Streets"),
      valuator = "button",
      default = 1,
      tooltip="Changes streets mode percentage to affect all themes or only urban.",
      gap = 1
    },

    {
      name="bool_prebuilt_levels",
      label=_("Prebuilt Levels"),
      valuator = "button",
      default = 1,
      tooltip = "Enable or disable prebuilt maps. When disabled, are replaced with generated maps instead."
    },

    {
      name = "float_layout_absurdity",
      label = _("Layout Absurdity"),
      valuator = "slider",
      units = "% of Levels",
      min = 0,
      max = 100,
      increment = 1,
      default = 0,
      nan = "",
      tooltip = "The layout absurdifier attempts to cause levels to overprefer specific shape " ..
      "rules from the ruleset in order to create odd and possibly broken but interesting combinations. " ..
      "Use at your own risk. These options will affect the amount of levels have the absurdity module activated on. " ..
      "Selecting ALL will not necessarily make all levels absurd as it is all still based on chance."
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
      gap = 1
    },

    { name="outdoors",     label=_("Outdoors"),   choices=STYLE_CHOICES },
    { name="caves",        label=_("Caves"),      choices=STYLE_CHOICES },
    { name="liquids",      label=_("Liquids"),    choices=STYLE_CHOICES },

    { name="hallways",     label=_("Hallways"),   choices=STYLE_CHOICES },
    { name="teleporters",  label=_("Teleports"),  choices=STYLE_CHOICES },
    { name="steepness",    label=_("Steepness"),  choices=STYLE_CHOICES },

    {
      name = "zdoom_vista",
      label = _("Bottomless Vistas"),
      choices=UI_ARCH.ZDOOM_VISTA_CHOICES,
      default="disable",
      tooltip = "This feature allows for vistas that show more of the skybox below the horizon. " ..
      "This does not prevent skybox tiling.\n" ..
      "Enable - Bottomless vistas can always show. Pick this choice when using 3D Skyboxes.\n" ..
      "Sky-gen Smart - Bottomless vistas appear only on episodes with no mountain backdrop based on the Sky Generator.\n" ..
      "Disable - Old Oblige behavior - no bottomless vistas."
    },

    {
      name = "zdoom_skybox",
      label = _("ZDoom 3D Skybox"),
      choices=UI_ARCH.ZDOOM_SKYBOX_CHOICES,
      default="disable",
      tooltip = "If a ZDoom based engine is selected, one has the option " ..
      "to enable a custom 3D skybox to be rendered into the map. " ..
      "It is preferable to put this on if you have ZDoom Vista enabled."
    }
  },
}
