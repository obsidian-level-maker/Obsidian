------------------------------------------------------------------------
--  MODULE: Debug Statement Control
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
-------------------------------------------------------------------

DEBUG_CONTROL = { }

DEBUG_CONTROL.MISSING_MAT_CHOICES =
{
  "ignore",  _("Ignore"),
  "warn",  _("Warn"),
  "abort", _("Abort"),
}

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

DEBUG_CONTROL.LIVEMAP_CHOICES =
{
  "step", _("Per Step (Very Slow)"),
  "room", _("Per Room (Slightly Slow)"),
  "none", _("No Live Minimap"),
}

function DEBUG_CONTROL.setup(self)

  module_param_up(self)

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

  tooltip = _("Provides options for printing out more verbose log information. Advanced, highly experimental features can also be found here."),

  hooks =
  {
    setup = DEBUG_CONTROL.setup,
    get_levels = DEBUG_CONTROL.get_levels
  },

  options =
  {

    {
      name = "bool_scale_items_with_map_size",
      label=_("Alternate Item Quantities"),
      valuator = "button",
      default = 0,
      tooltip = _("Scales item distribution with map size (Experimental)"),
      priority=105,
    },

    {
      name = "bool_print_fab_materials",
      label=_("Print Fab Materials"),
      valuator = "button",
      default = 0,
      tooltip = _("Print list of textures/flats present in each fab"),
      longtip = _("Print the names of all textures/flats preset in a prefab WAD. This will also list values like _FLOOR, _WALL, etc, prior to their conversion."),
      priority=104,
    },

    {
      name = "missing_material_behavior",
      label=_("Missing Fab Material Behavior"),
      choices=DEBUG_CONTROL.MISSING_MAT_CHOICES,
      default = "ignore",
      tooltip = _("Choose what to do when encountering a missing material"),
      longtip = _("Provides the following options if a material definition isn't present in a game's MATERIALS table: \n\nIgnore: Silently continue; missing materials are usually replaced by an _ERROR or _DEFAULT texture.\n\nWarn: Continue, but write the name of the fab and the missing material to the logfile.\n\nAbort: Throw an error and halt generation, with an error message explaining which fab and material are causing the issue. Will also write this information to the logfile."),
      priority=103,
    },

    {
      name = "bool_non_vanilla_as_missing",
      label=_("Check For Non-Vanilla Materials"),
      valuator = "button",
      default = 0,
      tooltip = _("Choose what to do when encountering a non-vanilla material"),
      longtip = _("If checked, will compare all flats/textures used against a list of vanilla materials for that IWAD, and treat non-vanilla materials as missing for the purposes of logging and throwing errors."),
      priority=102,
      gap = 1
    },

    {
      name = "bool_whole_names_only",
      label=_("Whole Name Gen Names Only"),
      valuator = "button",
      default = 0,
      tooltip = _("Use only complete names from the Name Generator"),
      longtip = _("Uses name generator names that are already complete phrases/sentences \ninstead of trying to procedurally generate them."),
      priority=101,
    },

    {
      name = "name_gen_test",
      label=_("Name Generator"),
      choices=DEBUG_CONTROL.NAME_GEN_CHOICES,
      tooltip = _("Prints a demonstration sample of 32 names per category.\nLevel Names = TECH, GOTHIC, URBAN, and BOSS level names\nTitle Names = TITLE, SUB_TITLE, and EPISODE names\n"),
      default="none",
      priority=100,
    },


    {
      name = "bool_print_story_strings",
      label=_("Print ZDoom Strings"),
      valuator = "button",
      default = 0,
      tooltip = _("Displays the story generator and custom quit message strings added by the ZDoom Special Addons: Story Generator."),
      priority=97,
    },


    {
      name = "float_build_levels",
      label = _("Build Level"),
      valuator = "slider",
      units = " only",
      min = 0,
      max = 45,
      increment = 1,
      default = 0,
      presets = "0:All",
      tooltip = _("Allows the skipping of level construction along the WAD for debugging purposes."),
      priority=96,
    },


    {
      name = "bool_shape_rule_stats",
      label = _("Shape Rule Stats"),
      valuator = "button",
      default = 0,
      tooltip = _("Displays usage statistics for shape grammar rules."),
      priority=95,
    },
    

    {
      name = "bool_save_svg",
      label = _("Save Map Previews"),
      valuator = "button",
      default = 0,
      tooltip = _("Saves SVG format images of generated map thumbnails."),
      priority=94,
      gap = 1,
    },


    {
      name = "bool_save_gif",
      label = _("Save Minimap GIF"),
      valuator = "button",
      default = 0,
      tooltip = _("Save an animated GIF of the building process. Recommended in combination with the Live Growth Minimap."),
      priority=94,
      gap = 1,
    },

    {
      name = "bool_suppress_nolimit_warning",
      label = _("Suppress NoLimit Warning"),
      valuator = "button",
      default = 0,
      tooltip = _("Suppress warning dialog when using Limit-Removing with the Doom family of games."),
      longtip = _("This warning only applies to the Doom series of games, as other supported games may only have Limit-Removing as a feasible choice."),
      priority = 61,
    },

    {
      name = "bool_experimental_games",
      label = _("Experimental Games"),
      valuator = "button",
      default = 0,
      tooltip = _("Enables building of levels for experimental games."),
      longtip = _("The following games are in an experimental status, meaning that they may have errors when building levels, or support for certain gameplay features has not been implemented yet:\n\nStrife"),
      priority = 60,
      gap = 1,
    },


    {
      name = "bool_custom_error_texture",
      label = _("Custom Error Texture"),
      valuator = "button",
      default = 0,
      tooltip = _("Replaces Obsidian's default texture with a high visibility version for easier detection of broken level geometry or missing textures."),
      priority = 50,
      gap = 1,
    },

    {
      name="live_minimap",
      label=_("Live Growth Minimap"),
      choices=DEBUG_CONTROL.LIVEMAP_CHOICES,
      default="none",
      tooltip= _("Controls the granularity of steps shown on the GUI minimap as a level is built."),
      longtip= _("Higher levels of detail will increase the amount of time that it takes to generate a WAD. If saving an animated GIF of the build process, its animation speed will also be affected by this setting (less detail=slower, more detail=faster).")
    },

--[[
    bool_attach_debug_info =
    {
      name = "bool_attach_debug_info",
      label = _("Attach DEBUG Info")
      valuator = "button",
      default = 0,
      tooltip = _("Attaches certain debug info into an OBLOGS text lump in the generated WAD."),
      priority = 91,
    }
]]
  },
}
