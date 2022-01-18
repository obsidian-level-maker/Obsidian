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
  for name,opt in pairs(self.options) do
    if OB_CONFIG.batch == "yes" then
      if opt.valuator then
        if opt.valuator == "slider" then 
          if opt.increment < 1 then
            PARAM[opt.name] = tonumber(OB_CONFIG[opt.name])
          else
            PARAM[opt.name] = int(tonumber(OB_CONFIG[opt.name]))
          end
        elseif opt.valuator == "button" then
          PARAM[opt.name] = tonumber(OB_CONFIG[opt.name])
        end
      else
        PARAM[opt.name] = OB_CONFIG[opt.name]
      end
      if RANDOMIZE_GROUPS then
        for _,group in pairs(RANDOMIZE_GROUPS) do
          if opt.randomize_group and opt.randomize_group == group then
            if opt.valuator then
              if opt.valuator == "button" then
                  PARAM[opt.name] = rand.sel(50, 1, 0)
                  goto done
              elseif opt.valuator == "slider" then
                  if opt.increment < 1 then
                    PARAM[opt.name] = rand.range(opt.min, opt.max)
                  else
                    PARAM[opt.name] = rand.irange(opt.min, opt.max)
                  end
                  goto done
              end
            else
              local index
              repeat
                index = rand.irange(1, #opt.choices)
              until (index % 2 == 1)
              PARAM[opt.name] = opt.choices[index]
              goto done
            end
          end
        end
      end
      ::done::
    else
	    if opt.valuator then
		    if opt.valuator == "button" then
		        PARAM[opt.name] = gui.get_module_button_value(self.name, opt.name)
		    elseif opt.valuator == "slider" then
		        PARAM[opt.name] = gui.get_module_slider_value(self.name, opt.name)      
		    end
      else
        PARAM[opt.name] = opt.value
	    end
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
    
    bool_save_svg =
    {
      name = "bool_save_svg",
      label = _("Save Map Previews"),
      valuator = "button",
      default = 0,
      tooltip = "Saves SVG format images of generated map thumbnails.",
      priority=94,
      gap = 1,
    },

    bool_save_gif =
    {
      name = "bool_save_gif",
      label = _("Save Minimap GIF"),
      valuator = "button",
      default = 0,
      tooltip = "Save an animated GIF of the building process. Recommended in combination with the Live Growth Minimap.",
      priority=94,
      gap = 1,
    },

    bool_experimental_games =
    {
      name = "bool_experimental_games",
      label = _("Experimental Games"),
      valuator = "button",
      default = 0,
      tooltip = "Enables building of levels for experimental games.",
      longtip = "The following games are in an experimental status, meaning that " ..
      "they may have errors when building levels, or support for certain gameplay features has" ..
      " not been implemented yet!\n\n" ..
      "HEXEN: MULTI-LEVEL WADs NOT RECOMMENDED! Hub system not yet implemented. Teleporter fabs not yet functional.\n\n" ..
      "STRIFE: MULTI-LEVEL WADs NOT RECOMMENDED! Hub/town system not yet implemented. Must use the \"rift01\" cheat code to start the first map.",
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

    {
      name="live_minimap",
      label=_("Live Growth Minimap"),
      choices=DEBUG_CONTROL.LIVEMAP_CHOICES,
      default="none",
      tooltip=_("Shows more steps Oblige performs on rooms as they are grown on the GUI minimap. May take a hit on generation speed.")
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
