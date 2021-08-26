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

function DEBUG_CONTROL.setup(self)
  for name,opt in pairs(self.options) do
    if opt.valuator then
      if opt.valuator == "button" then
        PARAM[opt.name] = gui.get_module_button_value(self.name, opt.name)
      elseif opt.valuator == "slider" then
        PARAM[opt.name] = gui.get_module_slider_value(self.name, opt.name)      
      end
    else
      PARAM[name] = self.options[name].value
    end
  end
end

function DEBUG_CONTROL.get_levels()
  if PARAM.custom_error_texture and PARAM.bool_custom_error_texture == 1 then
    GAME.MATERIALS._ERROR.t = "ZZWOLF7"
  end
end

function DEBUG_CONTROL.all_done()
  --[[if PARAM.attach_debug_info and PARAM.bool_attach_debug_info == 1 then
    local log_text = {}

    gui.wad_add_text_lump("OBLOGS", log_text)
  end]]

  if PARAM.custom_error_texture and PARAM.bool_custom_error_texture == 1 then
    gui.wad_merge_sections("games/doom/data/error_wall.wad")
  end
end

----------------------------------------------------------------

OB_MODULES["debugger"] =
{

  name = "debugger",

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

    bool_print_story_strings =
    {
      name = "bool_print_story_strings",
      label=_("Print ZDoom Strings"),
      valuator = "button",
      default = 0,
      tooltip="Displays the story generator and custom quit message strings "..
              "added by the ZDoom Special Addons: Story Generator.",
      priority=97,
    },

    float_build_levels =
    {
      name = "float_build_levels",
      label = _("Build Level"),
      valuator = "slider",
      units = " only",
      min = 0,
      max = 36,
      increment = 1,
      default = 0,
      presets = "0:All,",
      tooltip="Allows the skipping of level construction along the WAD " ..
              "for debugging purposes.",
      priority=96,
    },

    bool_shape_rule_stats =
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

    bool_extra_games =
    {
      name = "bool_extra_games",
      label = _("Extra Games"),
      valuator = "button",
      default = 0,
      tooltip = "Enables games other than Doom 2 in Game Settings list.",
      priority = 60,
      gap = 1,
    },

    bool_custom_error_texture =
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
    bool_attach_debug_info =
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
