------------------------------------------------------------------------
--  MODULE: Theme Control for DOOM
------------------------------------------------------------------------
--
--  Copyright (C) 2014-2016 Andrew Apted
--  Copyright (C) 2020 MsrSgtShooterPerson
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

  "tech",   "Tech",
  "urban",  "Urban",
  "hell",   "Hell",
  --[["wolf",   "Wolfenstein"]] --Sorry, boyos, this theme doesn't even exist at the moment.
  "egypt",  "Egypt (TNT)",
  "psycho", "Psychedelic",
}


THEME_CONTROL.MIXIN_CHOICES =
{
  "mostly", _("Mostly"),
  "normal", _("Normal"),
  "less",   _("Less"),
}


THEME_CONTROL.SIZE_CHOICES =
{
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


THEME_CONTROL.RAMP_FACTOR =
{
  "0.5",  _("Very Fast Curve"),
  "0.66", _("Fast Curve"),
  "1",    _("Linear"),
  "1.5",  _("Slow Curve"),
  "2",    _("Very Slow Curve"),
}


THEME_CONTROL.SIZE_BIAS =
{
  "small",   _("Smaller"),
  "default", _("DEFAULT"),
  "large",   _("Larger"),
}


function THEME_CONTROL.set_a_theme(LEV, opt)
  if opt.value == "no_change" then
    return
  end

  if opt.value == "egypt" and OB_CONFIG.game ~= "tnt" then
    error("Can only use Egypt theme with TNT Evilution.")
  end

  LEV.theme_name = opt.value
end


function THEME_CONTROL.get_levels(self)
  for name,opt in pairs(self.options) do
    local value = self.options[name].value
    PARAM[name] = value
  end

  for _,LEV in pairs(GAME.levels) do
    local name

    if LEV.is_secret then
      name = "secret"
    else
      name = "episode" .. tostring(LEV.episode.ep_index)
    end

    local opt = self.options[name]

    -- ignore unknown episodes
    if not opt then goto continue end

    THEME_CONTROL.set_a_theme(LEV, opt)
    ::continue::
  end
end


OB_MODULES["theme_ctl_doom2"] =
{
  label = _("[Exp] Doom 2 Theme Control"),

  game = "doom2",

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


OB_MODULES["level_control"] =
{
  label = _("Level/Theme Control"),

--  game = "doomish",

  priority = 103,

  hooks =
  {
    get_levels = THEME_CONTROL.get_levels
  },

  options =
  {
    mixin_type =
    {
      name = "mixin_type",
      label = _("Mix-in Type"),
      priority = 7,
      tooltip = "This replaces the -ish theme choices. By selecting mostly, this means " ..
                "your selected theme is occasionally littered by other themes while setting it to " ..
                "less means the original selected theme is what's littered in instead. " ..
                "Default behavior is normal.",
      choices = THEME_CONTROL.MIXIN_CHOICES,
      default = "normal",
      gap = 1,
    },

    level_upper_bound =
    {
      name = "level_upper_bound",
      label = _("Upper Bound"),
      priority = 6,
      tooltip = "Fine tune upper limit for Level Size Episodic, Progressive and Mixed options.",
      choices = THEME_CONTROL.SIZE_CHOICES,
      default = "trans",
    },

    level_lower_bound =
    {
      name = "level_lower_bound",
      label = _("Lower Bound"),
      priority = 5,
      tooltip = "Fine tune lower limit for Level Size Episodic, Progressive and Mixed options.",
      choices = THEME_CONTROL.SIZE_CHOICES,
      default = "micro",
      gap = 1,
    },

    level_size_ramp_factor =
    {
      name = "level_size_ramp_factor",
      label = _("Ramp Factor"),
      priority = 4,
      tooltip = "Determines how fast or slow larger level sizes are reached in Progressive/Episodic mode.\n\n" ..
      "Very Fast Curve: Reach half-size at 1/4th of the game.\n" ..
      "Fast Curve: Reach half-size at 1/3rds.\n" ..
      "Linear: Reach half-size at half the game.\n" ..
      "Slow Curve: Reach half-size at 2/3rds.\n" ..
      "Very Slow Curve: Reach half-size at 3/4ths.\n\n" ..
      "Oblige default is Fast Curve.",
      choices = THEME_CONTROL.RAMP_FACTOR,
      default = "0.66",
      gap = 1,
    },

    level_size_bias =
    {
      name = "level_size_bias",
      label = _("Level Size Bias"),
      priority = 3,
      tooltip = "Alters probability skew when using Mix It Up for level sizes. " ..
      "DEFAULT is a normal curve where Average is the most common size while smaller or larger sizes " ..
      "become rarer. Combine with Level Upper and Lower Bounds for greater control.",
      choices = THEME_CONTROL.SIZE_BIAS,
      default = "default",
    },
  },
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
  label = _("[Exp] Doom 1 Theme Control"),

  game = "doom1",

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
