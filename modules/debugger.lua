------------------------------------------------------------------------
--  MODULE: Debug Statement Control
------------------------------------------------------------------------
--
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
-------------------------------------------------------------------

DEBUG_CONTROL = { }

DEBUG_CONTROL.NAME_GEN_CHOICES =
{
  "32l",  _("Test Level Names"),
  "32t",  _("Test Title Names"),
  "none", _("None"),
}

DEBUG_CONTROL.GROWTH_STEP_CHOICES =
{
  "showmore", _("Show All Steps"),
  "show",     _("Show Successful Steps Only"),
  "no",       _("No"),
}

DEBUG_CONTROL.LEVEL_NUM_CHOICES =
{
  "all", _("All"),
  "1",   _("1 only"),
  "2",   _("2 only"),
  "3",   _("3 only"),
  "4",   _("4 only"),
  "5",   _("5 only"),
  "6",   _("6 only"),
  "7",   _("7 only"),
  "8",   _("8 only"),
  "9",   _("9 only"),
  "10",   _("10 only"),
  "11",   _("11 only"),
  "12",   _("12 only"),
  "13",   _("13 only"),
  "14",   _("14 only"),
  "15",   _("15 only"),
  "16",   _("16 only"),
  "17",   _("17 only"),
  "18",   _("18 only"),
  "19",   _("19 only"),
  "20",   _("20 only"),
  "21",   _("21 only"),
  "22",   _("22 only"),
  "23",   _("23 only"),
  "24",   _("24 only"),
  "25",   _("25 only"),
  "26",   _("26 only"),
  "27",   _("27 only"),
  "28",   _("28 only"),
  "29",   _("29 only"),
  "30",   _("30 only"),
  "31",   _("31 only"),
  "32",   _("32 only"),
  "33",   _("33 only"),
  "34",   _("34 only"),
  "35",   _("35 only"),
  "36",   _("36 only"),
}

function DEBUG_CONTROL.setup(self)
  for name,opt in pairs(self.options) do
    local value = self.options[name].value
    PARAM[name] = value
  end
end

function DEBUG_CONTROL.get_levels()
  if PARAM.custom_error_texture and gui.get_module_button_value("debugger", "bool_custom_error_texture") == 1 then
    GAME.MATERIALS._ERROR.t = "ZZWOLF7"
  end
end

function DEBUG_CONTROL.all_done()
  --[[if PARAM.attach_debug_info and gui.get_module_button_value("debugger", "bool_attach_debug_info") == 1 then
    local log_text = {}

    gui.wad_add_text_lump("OBLOGS", log_text)
  end]]

  if PARAM.custom_error_texture and gui.get_module_button_value("debugger", "bool_custom_error_texture") == 1 then
    gui.wad_merge_sections("games/doom/data/error_wall.wad")
  end
end

----------------------------------------------------------------

OB_MODULES["debugger"] =
{
  label = _("Debug Control"),

  side = "left",
  engine = "!vanilla",
  priority = 50,

  tooltip = "Provides options for printing out more verbose log information. " ..
            "Advanced, highly experimental features can also be found here.",

  hooks =
  {
    setup = DEBUG_CONTROL.setup,
    get_levels = DEBUG_CONTROL.get_levels
  },

  options =
  {
    name_gen_test =
    {
      name = "name_gen_test",
      label=_("Name Generator"),
      choices=DEBUG_CONTROL.NAME_GEN_CHOICES,
      tooltip="Prints a demonstration sample of 32 names per category.\n" ..
              "Level Names = TECH, GOTHIC, URBAN, and BOSS level names\n" ..
              "Title Names = TITLE, SUB_TITLE, and EPISODE names\n",
      default="none",
      priority=100,
    },

    print_prefab_use =
    {
      name = "bool_print_prefab_use",
      label=_("Print Prefab Usage"),
      valuator = "button",
      default = 0,
      tooltip="Lists prefabs spawned per map.",
      priority=98,
    },

    print_story_strings =
    {
      name = "bool_print_story_strings",
      label=_("Print ZDoom Strings"),
      valuator = "button",
      default = 0,
      tooltip="Displays the story generator and custom quit message strings "..
              "added by the ZDoom Special Addons: Story Generator.",
      priority=97,
    },

    build_levels =
    {
      name = "build_levels",
      label = _("Build Level"),
      choices=DEBUG_CONTROL.LEVEL_NUM_CHOICES,
      tooltip="Allows the skipping of level construction along the WAD " ..
              "for debugging purposes.",
      default="all",
      priority=96,
    },

    shape_rule_stats =
    {
      name = "bool_shape_rule_stats",
      label = _("Shape Rule Stats"),
      valuator = "button",
      default = 0,
      tooltip = "Displays usage statistics for shape grammar rules.",
      priority=95,
    },
    
    save_svg =
    {
      name = "bool_save_svg",
      label = _("Save Map Previews"),
      valuator = "button",
      default = 0,
      tooltip = "Saves SVG format images of generated map thumbnails.",
      priority=94,
      gap = 1,
    },

    extra_games =
    {
      name = "bool_extra_games",
      label = _("Extra Games"),
      valuator = "button",
      default = 0,
      tooltip = "Enables games other than Doom 2 in Game Settings list.",
      priority = 60,
      gap = 1,
    },

    custom_error_texture =
    {
      name = "bool_custom_error_texture",
      label = _("Custom Error Texture"),
      valuator = "button",
      default = 0,
      tooltip = "Replaces Obsidian's default texture with a high visibility version " ..
        "for easier detection of broken level geometry or missing textures.",
      priority = 50,
      gap = 1,
    },

--[[
    attach_debug_info =
    {
      name = "bool_attach_debug_info",
      label = _("Attach DEBUG Info")
      valuator = "button",
      default = 0,
      tooltip = "Attaches certain debug info into an OBLOGS text lump in the generated WAD.",
      priority = 91,
    }
]]
  },
}
