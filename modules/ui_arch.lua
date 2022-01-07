------------------------------------------------------------------------
--  PANEL: Architecture
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

UI_ARCH.MIXIN_CHOICES =
{
  "mostly", _("Mostly"),
  "normal", _("Normal"),
  "less",   _("Less"),
}


UI_ARCH.RAMP_FACTOR =
{
  "0.5",  _("Very Fast Curve"),
  "0.66", _("Fast Curve"),
  "1",    _("Linear"),
  "1.5",  _("Slow Curve"),
  "2",    _("Very Slow Curve"),
}


UI_ARCH.SIZE_BIAS =
{
  "small",   _("Smaller"),
  "default", _("DEFAULT"),
  "large",   _("Larger"),
}

function UI_ARCH.setup(self)
  -- these parameters have to be instantiated in this hook
  -- because begin_level happens *after* level size decisions
  for _,opt in pairs(self.options) do
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
  
  if OB_CONFIG.engine ~= "vanilla" then
    if OB_CONFIG.batch == "yes" or type(PARAM.float_size) ~= "string" then
      SEED_W = 90
      SEED_H = 90
    else
      if type(PARAM.float_size) == "string" then -- Use upper bound for Mix It Up, Progressive, and Episodic level sizes - Dasho
      -- MSSP: the absolute maximum size is tightened down to the largest
      -- agreed map size for performance's sake. Current agreed maximum is 74 W.
      -- any higher will cause skyboxes and teleporter rooms to start merging with
      -- the main map.

      -- Dasho: This shifts the default value of 90 for SEED_W and SEED_H to here instead of defs.lua. It will remain 90 unless someone
      -- who is using slider overrides sets extremely high values for Level Size, then it is changed to prevent assertion errors later on.
        if (PARAM.float_level_upper_bound > 86) then
          SEED_W = PARAM.float_level_upper_bound + 4
          SEED_H = PARAM.float_level_upper_bound + 4
        else
          SEED_W = 90
          SEED_H = 90
        end
		  else
        if (PARAM.float_size > 86) then
          SEED_W = PARAM.float_size + 4
          SEED_H = PARAM.float_size + 4
        else
          SEED_W = 90
          SEED_H = 90
        end
		  end
	  end
  end 
end

OB_MODULES["ui_arch"] =
{
  name = "ui_arch",

  label = _("Architecture"),
    
  -- color = { red = 125, green = 125, blue = 125 }, -- This is an example of setting a custom per-module color - Dasho

  side = "left",
  priority = 104,
  engine = "!vanilla",

  hooks = 
  {
    setup = UI_ARCH.setup,
  },

  options =
  {

    float_size=
    { 
      name="float_size", 
      label=_("Level Size"),
      valuator = "slider",
      units = "",
      min = 10,
      max = 75,
      increment = 1,
      default = 36,
      nan = "Mix It Up,Episodic,Progressive,",
      presets = "10:10 (Microscopic)," ..
      "16:16 (Miniature)," ..
      "22:22 (Tiny)," ..
      "30:30 (Small)," ..
      "36:36 (Average)," ..
      "42:42 (Large)," ..
      "48:48 (Huge)," ..
      "58:58 (Colossal)," ..
      "66:66 (Gargantuan)," ..
      "75:75 (Transcendent),",
      tooltip = "Determines size of map (Width x Height) in grid squares.",
      longtip = "WARNING! If you are planning to play on any choices that involve maps " ..
      "at sizes of 50 and above, Autodetail is required on. (on by default if you do not have " ..
      "Prefab Control module on. The stability of maps with sizes 60 and beyond is not predictable.",
      priority = 100,
      randomize_group="architecture"
    },

    float_level_upper_bound =
    {
      name = "float_level_upper_bound",
      label = _("Upper Bound"),
      valuator = "slider",
      units = "",
      min = 10,
      max = 75,
      increment = 1,
      default = 75,
      presets = "10:10 (Microscopic)," ..
      "16:16 (Miniature)," ..
      "22:22 (Tiny)," ..
      "30:30 (Small)," ..
      "36:36 (Average)," ..
      "42:42 (Large)," ..
      "48:48 (Huge)," ..
      "58:58 (Colossal)," ..
      "66:66 (Gargantuan)," ..
      "75:75 (Transcendent),",
      tooltip = "Fine tune upper limit when Level Size is set to Episodic, Progressive or Mixed.",
      priority = 99,
    },

    float_level_lower_bound =
    {
      name = "float_level_lower_bound",
      label = _("Lower Bound"),
      valuator = "slider",
      units = "",
      min = 10,
      max = 75,
      increment = 1,
      default = 10,
      presets = "10:10 (Microscopic)," ..
      "16:16 (Miniature)," ..
      "22:22 (Tiny)," ..
      "30:30 (Small)," ..
      "36:36 (Average)," ..
      "42:42 (Large)," ..
      "48:48 (Huge)," ..
      "58:58 (Colossal)," ..
      "66:66 (Gargantuan)," ..
      "75:75 (Transcendent),",
      tooltip = "Fine tune lower limit when Level Size is set to Episodic, Progressive or Mixed.",
      priority = 98,
      gap = 1,
    },

    level_size_ramp_factor =
    {
      name = "level_size_ramp_factor",
      label = _("Ramp Factor"),
      tooltip = "Determines how fast or slow larger level sizes are reached in Progressive/Episodic mode.",
      longtip = "Very Fast Curve: Reach half-size at 1/4th of the game.\n" ..
      "Fast Curve: Reach half-size at 1/3rds.\n" ..
      "Linear: Reach half-size at half the game.\n" ..
      "Slow Curve: Reach half-size at 2/3rds.\n" ..
      "Very Slow Curve: Reach half-size at 3/4ths.\n\n" ..
      "Obsidian default is Fast Curve.",
      choices = UI_ARCH.RAMP_FACTOR,
      default = "0.66",
      priority = 97,
      randomize_group="architecture"
    },

    level_size_bias =
    {
      name = "level_size_bias",
      label = _("Level Size Bias"),
      tooltip = "Alters probability skew when using Mix It Up for level sizes.",
      longtip = "DEFAULT is a normal curve where Average is the most common size while smaller or larger sizes " ..
      "become rarer.\n\nCombine with Level Upper and Lower Bounds for greater control.",
      choices = UI_ARCH.SIZE_BIAS,
      default = "default",
      priority = 96,
      randomize_group="architecture"
    },

    mixin_type =
    {
      name = "mixin_type",
      label = _("Theme Mix-in Type"),
      tooltip = "This replaces the -ish theme choices. By selecting mostly, this means " ..
                "your selected theme is occasionally littered by other themes while setting it to " ..
                "less means the original selected theme is what's littered in instead. " ..
                "Default behavior is normal.",
      choices = UI_ARCH.MIXIN_CHOICES,
      default = "normal",
      priority = 88,
      gap = 1,
      randomize_group="architecture"
    },
  
    float_linear_mode=
    {
      name = "float_linear_mode",
      label = _("Linear Mode"),
      valuator = "slider",
      units = "% of Levels",
      min = 0,
      max = 100,
      increment = 1,
      default = 0,
      presets = "",
      tooltip = "Creates linear levels, where rooms are connected along a " ..
      "linear layout from start to exit.",
      longtip = "Due to the nature of linear levels, " ..
      "you may encounter teleports even if you have teleports off. This is necessary " ..
      "in order for linear levels not to prematuraly terminate and therefore become stunted " ..
      "i.e. only have 2-5 rooms.",
      priority = 85,
      randomize_group="architecture"
    },

    float_nature_mode=
    {
      name = "float_nature_mode",
      label = _("Nature Mode"),
      valuator = "slider",
      units = "% of Levels",
      min = 0,
      max = 100,
      increment = 1,
      default = 0,
      presets = "",
      tooltip = "Forces most of the map to be composed of naturalistic areas (parks and caves). " ..
      "The ratio is decided by Outdoors style setting while competing styles are ignored.",
      priority = 84,
      randomize_group="architecture"
    },

    float_streets_mode=
    {
      name = "float_streets_mode",
      label = _("Streets Mode"),
      valuator = "slider",
      units = "% of Levels",
      min = 0,
      max = 100,
      increment = 1,
      default = 15,
      presets = "",
      tooltip = "Allows Oblige to create large street-like outdoor rooms.",
      priority = 83,
      randomize_group="architecture"
    },

    bool_urban_streets_mode=
    {
      name = "bool_urban_streets_mode",
      label=_("Urban Only Streets"),
      valuator = "button",
      default = 1,
      tooltip="Changes streets mode percentage to affect all themes or only urban.",
      gap = 1,
      priority = 82,
    },

    bool_prebuilt_levels=
    {
      name="bool_prebuilt_levels",
      label=_("Prebuilt Levels"),
      valuator = "button",
      default = 1,
      tooltip = "Enable or disable prebuilt maps. When disabled, are replaced with generated maps instead.",
      longtip = "Prebuilt levels are useful when, for example, a boss encounter like the Icon of Sin is desired." ..
      "This sort of level would be very difficult to generate procedurally, and thus a handmade map is used instead.",
      priority = 81,
      gap = 1
    },

    float_layout_absurdity=
    {
      name = "float_layout_absurdity",
      label = _("Layout Absurdity"),
      valuator = "slider",
      units = "% of Levels",
      min = 0,
      max = 100,
      increment = 1,
      default = 0,
      presets = "",
      tooltip = "Chance that a level will be built using an ususual/irregular layout.",
      longtip = "The layout absurdifier attempts to cause levels to overprefer specific shape " ..
      "rules from the ruleset in order to create odd and possibly broken but interesting combinations. " ..
      "Use at your own risk. These options will affect the amount of levels have the absurdity module activated on. " ..
      "Selecting ALL will not necessarily make all levels absurd as it is all still based on chance.",
      gap = 1,
      priority = 80,
      randomize_group="architecture"
    },

    outdoors = { name="outdoors",     label=_("Outdoors"),   choices=STYLE_CHOICES, priority = 78, randomize_group="architecture" },
    caves = { name="caves",        label=_("Caves"),      choices=STYLE_CHOICES, priority = 77, randomize_group="architecture" },
    liquids = { name="liquids",      label=_("Liquids"),    choices=STYLE_CHOICES, priority = 76, randomize_group="architecture" },
    hallways = { name="hallways",     label=_("Hallways"),   choices=STYLE_CHOICES, priority = 75, randomize_group="architecture" },
    teleporters = { name="teleporters",  label=_("Teleports"),  choices=STYLE_CHOICES, priority = 74, randomize_group="architecture" },
    steepness = { name="steepness",    label=_("Steepness"),  choices=STYLE_CHOICES, gap=1, priority = 73, randomize_group="architecture" },

    zdoom_vista=
    {
      name = "zdoom_vista",
      label = _("Bottomless Vistas"),
      choices=UI_ARCH.ZDOOM_VISTA_CHOICES,
      default="disable",
      tooltip = "This feature allows for vistas that show more of the skybox below the horizon. " ..
      "This does not prevent skybox tiling.",
      longtip = "Enable - Bottomless vistas can always show. Pick this choice when using 3D Skyboxes.\n\n" ..
      "Sky-gen Smart - Bottomless vistas appear only on episodes with no mountain backdrop based on the Sky Generator.\n\n" ..
      "Disable - Old Oblige behavior - no bottomless vistas.",
      priority = 50
    },

    zdoom_skybox=
    {
      name = "zdoom_skybox",
      label = _("ZDoom 3D Skybox"),
      choices=UI_ARCH.ZDOOM_SKYBOX_CHOICES,
      default="disable",
      tooltip = "If a ZDoom based engine is selected, one has the option " ..
      "to enable a custom 3D skybox to be rendered into the map. " ..
      "It is preferable to put this on if you have ZDoom Vista enabled.",
      priority = 49
    }
  },
}
