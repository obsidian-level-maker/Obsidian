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

UI_SLUMP = { }

UI_SLUMP.MON_VARIETY =
{
  "normal", _("Normal"),
  "shooters", _("Ranged Only"),
  "noflyzone", _("No Fly Zone"),
  "nazis", _("Oops! All Nazis!")
}

function UI_SLUMP.setup(self)
  -- these parameters have to be instantiated in this hook
  -- because begin_level happens *after* level size decisions
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

OB_MODULES["ui_slump_arch"] =
{

  name = "ui_slump_arch",

  label = _("SLUMP Architecture"),

  side = "left",
  priority = 104,
  engine = "vanilla",

  hooks = 
  {
    setup = UI_SLUMP.setup,
  },

  options =
  {
    { 
      name="float_minrooms_slump",
      label=_("Level Size"),
      valuator = "slider",
      units = " Rooms",
      min = 1,
      max = 37,
      increment = 1,
      default = 15,
      nan = "Mix It Up,",
      presets = "",
      tooltip = "Minimum number of rooms per level."
    },

    {
      name = "float_bigify_slump",
      label = _("Room Bigification Chance"),
      valuator = "slider",
      units = "%",
      min = 0,
      max = 100,
      increment = 1,
      default = 50,
      presets = "",
      tooltip = "% chance that SLUMP will attempt to grow a room."
    },
    
    {
      name = "float_forkiness_slump",
      label = _("Forkiness"),
      valuator = "slider",
      units = "%",
      min = 0,
      max = 100,
      increment = 1,
      default = 50,
      presets = "",
      tooltip = "% chance that a room will attempt to fork as the level grows. "..
                "0% should be a bunch of murder hallways. Forks are not guaranteed " ..
                "to succeed, especially if the room bigification chance is increased."
    },

    {
      name = "bool_dm_starts_slump",
      label = _("Deathmatch Spawns"),
      valuator = "button",
      default = 0,
      tooltip = "Add Deathmatch starts to generated levels."
    },
    
    {
      name = "bool_major_nukage_slump",
      label = _("Major Nukage Mode"),
      valuator = "button",
      default = 0,
      tooltip = "Watch your step!"
    },
    
    {
      name = "bool_immediate_monsters_slump",
      label = _("Quiet Start"),
      valuator = "button",
      default = 1,
      tooltip = "Prevents monsters from spawning in the starting room. Monsters in other rooms may still have" ..
                " a line of sight to you, so be careful!"
    }
  }
}

OB_MODULES["ui_slump_mons"] =
{

  name = "ui_slump_mons",

  label = _("SLUMP Monsters"),

  side = "right",
  priority = 103,
  engine = "vanilla",

  hooks = 
  {
    setup = UI_SLUMP.setup,
  },

  options =
  {
    {
      name = "slump_mons",
      label = _("Monster Variety"),
      choices = UI_SLUMP.MON_VARIETY,
      default = "normal",
      tooltip = "Control what types of monsters are available"
    },
  }
}
