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
  "epi",   _("Episodic (MAP11, MAP20, MAP30)"),
  "2epi",   _("2 per ep (5,11,16,20,25,30)"),
  "3epi",   _("3 per ep (3,7,11,14,17,20,23,27,30)"),
  "4epi",   _("4 per ep (3,6,9,11,14,16,18,20,23,26,28,30)"),
  "_",     _("_"),
  "5p",    _("5% Chance, Any Map After MAP04"),
  "10p",   _("10% Chance, Any Map After MAP04"),
  "all",   _("Everything")
}

function PROCEDURAL_GOTCHA_FINE_TUNE.setup(self)
  for name,opt in pairs(self.options) do
    if OB_CONFIG.batch == "yes" then
      if opt.valuator then
        if opt.valuator == "slider" then 
          local value = tonumber(OB_CONFIG[opt.name])
          if not value then
            PARAM[opt.name] = OB_CONFIG[opt.name]
          else
            if opt.increment < 1 then
              PARAM[opt.name] = value
            else
              PARAM[opt.name] = int(value)
            end
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

  tooltip=_(
    "This module allows you to fine tune the Procedural Gotcha experience if you have Procedural Gotchas enabled. Does not affect prebuilts. It is recommended to pick higher scales on one of the two options, but not both at once for a balanced challenge."),

  options =
  {
    gotcha_frequency=   
    {
      name="gotcha_frequency",
      label=_("Gotcha Frequency"),
      choices=PROCEDURAL_GOTCHA_FINE_TUNE.PROC_GOTCHA_CHOICES,
      default="final",
      tooltip = "Procedural Gotchas are two room maps, where the second is an immediate " ..
      "but immensely-sized exit room with gratitiously intensified monster strength. " ..
      "Essentially an arena - prepare for a tough, tough fight!\n\nNotes:\n\n" ..
      "5% of levels may create at least 1 or 2 gotcha maps in a standard full game.",
      priority = 100
    },
    
    float_gotcha_qty =
    {
      name="float_gotcha_qty",
      label=_("Extra Quantity"),
      valuator = "slider",
      units = "x Monsters",
      min = 0.2,
      max = 10,
      increment = 0.1,
      default = 1.2,
      presets = "",
      tooltip = "Offset monster strength from your default quantity of choice plus the increasing level ramp. If your quantity choice is to reduce the monsters, the monster quantity will cap at a minimum of 0.1 (Scarce quantity setting).",
    },

    float_gotcha_strength =
    {
      name="float_gotcha_strength",
      label=_("Extra Strength"),
      valuator = "slider",
      units = "",
      min = 0,
      max = 16,
      increment = 1,
      default = 4,
      presets = "0:NONE," ..
      "2:2 (Stronger)," ..
      "4:4 (Harder)," ..
      "6:6 (Tougher)," ..
      "8:8 (CRAZIER)," ..
      "16:16 (NIGHTMARISH),",
      tooltip = "Offset monster quantity from your default strength of choice plus the increasing level ramp.",
    },

    gotcha_map_size =
    {
      name="gotcha_map_size",
      label=_("Map Size"),
      choices=PROCEDURAL_GOTCHA_FINE_TUNE.GOTCHA_MAP_SIZES,
      default = "small",
      tooltip = "Size of the procedural gotcha. Start and arena room sizes are relative to map size as well.",
    },
  },
}
