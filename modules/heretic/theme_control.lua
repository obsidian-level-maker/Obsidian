------------------------------------------------------------------------
--  MODULE: Theme Control for Heretic
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

HERETIC_THEME_CONTROL = { }

HERETIC_THEME_CONTROL.CHOICES =
{
  "no_change", _("NO CHANGE"),
  "city",       _("City"),
  "maw",      _("Maw"),
  "dome",       _("Dome"),
  "ossuary",      _("Ossuary"),
  "demense",     _("Demense"),
  "psycho",     _("Psychedelic"),
  "minisodic",  _("Minisodic"),
}

HERETIC_THEME_CONTROL.MINISODE_LIST =
{
  [1] = {"city"}, 
  [2] = {"city", "maw"},
  [3] = {"maw"}, 
  [4] = {"dome"}, 
  [5] = {"dome", "ossuary"},
  [6] = {"ossuary"},
  [7] = {"ossuary", "demense"},
  [8] = {"demense"},
  [9] = {"city", "maw", "dome", "ossuary", "demense"},
}


function HERETIC_THEME_CONTROL.set_a_theme(LEV, opt)
  if opt.value == "no_change" then
    return
  end

  LEV.theme_name = opt.value

  if opt.value == "minisodic" then
    LEV.theme_name = rand.pick(HERETIC_THEME_CONTROL.MINISODE_LIST[tonumber(string.sub(LEV.name, 4))])
  end
end


function HERETIC_THEME_CONTROL.get_levels(self)
  
  module_param_up(self)

  for _,LEV in pairs(GAME.levels) do
    local name

    if LEV.is_secret then
      name = "secret"
    else
      name = "episode" .. tostring(LEV.episode.ep_index)
    end

    local option

    for _,opt in pairs(self.options) do
      if name == opt.name then
        option = opt
        goto foundit
      end
    end

    ::foundit::

    if not option then goto continue end
    HERETIC_THEME_CONTROL.set_a_theme(LEV, option)
    ::continue::
  end
  
end


OB_MODULES["theme_ctl_heretic"] =
{

  name = "theme_ctl_heretic",

  label = _("[Exp] Heretic Theme Control"),

  game = "heretic",
  engine = "idtech_1",
  port = "!limit_enforcing",
  where = "other",

  hooks =
  {
    get_levels = HERETIC_THEME_CONTROL.get_levels
  },

  options =
  {
    { name = "episode1", 
    label=_("Episode 1"), 
    tooltip=_("Override regular theme for Episode 1."),     
    choices=HERETIC_THEME_CONTROL.CHOICES, default = "no_change", randomize_group="architecture" },
    { name = "episode2", 
    label=_("Episode 2"), 
    tooltip=_("Override regular theme for Episode 2."),    
    choices=HERETIC_THEME_CONTROL.CHOICES, default = "no_change", randomize_group="architecture", },
    { name = "episode3", 
    label=_("Episode 3"), 
    tooltip=_("Override regular theme for Episode 3."),    
    choices=HERETIC_THEME_CONTROL.CHOICES, default = "no_change", randomize_group="architecture", },
    { name = "episode4", 
    label=_("Episode 4"), 
    tooltip=_("Override regular theme for Episode 4."),    
    choices=HERETIC_THEME_CONTROL.CHOICES, default = "no_change", randomize_group="architecture", },
    { name = "episode5", 
    label=_("Episode 5"), 
    tooltip=_("Override regular theme for Episode 5."),    
    choices=HERETIC_THEME_CONTROL.CHOICES, default = "no_change", randomize_group="architecture", },
    { name = "secret", 
    label=_("Secret Levels"), 
    tooltip=_("Override regular theme for Secret Levels."), 
    choices=HERETIC_THEME_CONTROL.CHOICES, default = "no_change", randomize_group="architecture", },
  },

  tooltip = _("Warning: Mix-ins are for now completely overriden when picking a choice with change."),
}