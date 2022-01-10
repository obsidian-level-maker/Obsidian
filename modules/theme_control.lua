------------------------------------------------------------------------
--  MODULE: Theme Control for DOOM
------------------------------------------------------------------------
--
--  Copyright (C) 2014-2016 Andrew Apted
--  Copyright (C) 2021-2022 MsrSgtShooterPerson
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

THEME_CONTROL = { }

THEME_CONTROL.CHOICES =
{
  "no_change", "NO CHANGE",

  "tech",       "Tech",
  "urban",      "Urban",
  "hell",       "Hell",
  --[["wolf",   "Wolfenstein"]] --Sorry, boyos, this theme doesn't even exist at the moment.
  "egypt",      "Egypt (TNT)",
  "psycho",     "Psychedelic",
  "minisodic",  "Minisodic",
}


THEME_CONTROL.DOOM2_MINISODE_LIST =
{
  MAP01 = "tech", 
  MAP02 = "tech",
  MAP03 = "tech", 
  MAP04 = "tech", 
  MAP05 = "urban",
  MAP06 = "urban",
  MAP07 = "urban",
  MAP08 = "urban",
  MAP09 = "hell",
  MAP10 = "hell",
  MAP11 = "hell",

  MAP12 = "tech",
  MAP13 = "tech",
  MAP14 = "tech",
  MAP15 = "urban",
  MAP16 = "urban",
  MAP17 = "urban",
  MAP18 = "hell",
  MAP19 = "hell",
  MAP20 = "hell",

  MAP21 = "tech",
  MAP22 = "tech",
  MAP23 = "tech",
  MAP24 = "urban",
  MAP25 = "urban",
  MAP26 = "urban",
  MAP27 = "hell",
  MAP28 = "hell",
  MAP29 = "hell",
  MAP30 = "hell"
}


function THEME_CONTROL.set_a_theme(LEV, opt)
  if opt.value == "no_change" then
    return
  end

  if opt.value == "egypt" and OB_CONFIG.game ~= "tnt" then
    error("Can only use Egypt theme with TNT Evilution.")
  end

  LEV.theme_name = opt.value

  if opt.value == "minisodic" then
    LEV.theme_name = THEME_CONTROL.DOOM2_MINISODE_LIST[LEV.name]
  end
end


function THEME_CONTROL.get_levels(self)
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
              PARAM[opt.name] = rand.pick(opt.choices)
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

  for _,LEV in pairs(GAME.levels) do
    local name

    if LEV.is_secret then
      name = "secret"
    else
      name = "episode" .. tostring(LEV.episode.ep_index)
    end

    local opt = self.options[name]

    if not opt then goto continue end
    THEME_CONTROL.set_a_theme(LEV, opt)
    ::continue::
  end
end


OB_MODULES["theme_ctl_doom2"] =
{

  name = "theme_ctl_doom2",

  label = _("[Exp] Doom 2 Theme Control"),

  game = "doom2",
  engine = "!vanilla",

  hooks =
  {
    get_levels = THEME_CONTROL.get_levels
  },

  options =
  {
    episode1  = { label="Episode 1",     choices=THEME_CONTROL.CHOICES, default = "no_change" },
    episode2  = { label="Episode 2",     choices=THEME_CONTROL.CHOICES, default = "no_change" },
    episode3  = { label="Episode 3",     choices=THEME_CONTROL.CHOICES, default = "no_change" },
    secret    = { label="Secret Levels", choices=THEME_CONTROL.CHOICES, default = "no_change" },
  },

  tooltip = "Warning: Mix-ins are for now completely overriden when picking a choice with change.",
}

------------------------------------------------------------------------

THEME_CONTROL.DOOM1_CHOICES =
{
  "no_change", "NO CHANGE",

  "tech",   "Tech",
  "deimos", "Deimos",
  "hell",   "Hell",
  "flesh",  "Flesh",

  "psycho", "Psychedelic",
}


OB_MODULES["theme_ctl_doom1"] =
{

  name = "theme_ctl_doom1",

  label = _("[Exp] Doom 1 Theme Control"),

  game = "doom1",
  engine = "!vanilla",

  hooks =
  {
    -- using same function for both Doom 1 and Doom 2 modules
    get_levels = THEME_CONTROL.get_levels
  },

  options =
  {
    episode1  = { label="Episode 1",     choices=THEME_CONTROL.DOOM1_CHOICES, default = "no_change" },
    episode2  = { label="Episode 2",     choices=THEME_CONTROL.DOOM1_CHOICES, default = "no_change" },
    episode3  = { label="Episode 3",     choices=THEME_CONTROL.DOOM1_CHOICES, default = "no_change" },
    episode4  = { label="Episode 4",     choices=THEME_CONTROL.DOOM1_CHOICES, default = "no_change" },
    secret    = { label="Secret Levels", choices=THEME_CONTROL.DOOM1_CHOICES, default = "no_change" },
  },

  tooltip = "Warning: Mix-ins are for now completely overriden when picking a choice with change.",
}
