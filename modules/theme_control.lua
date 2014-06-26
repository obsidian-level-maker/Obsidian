------------------------------------------------------------------------
--  MODULE: Theme Control for DOOM
------------------------------------------------------------------------
--
--  Copyright (C) 2014 Andrew Apted
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
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
  "no_change", "NO CHANGE"

  "tech",   "Tech"
  "urban",  "Urban"
  "hell",   "Hell"
  "wolf",   "Wolfenstein"
  "egypt",  "Egypt (TNT)"

  "psycho", "Psychedelic"
}


function THEME_CONTROL.set_a_theme(LEV, opt)
  if opt.value == "no_change" then
    return
  end

  if opt.value == "egypt" and OB_CONFIG.game != "tnt" then
    error("Can only use Egypt theme with TNT Evilution.")
  end

  LEV.theme_name = opt.value
end


function THEME_CONTROL.get_levels(self)
  each LEV in GAME.levels do
    local name

    if LEV.is_secret then
      name = "secret"
    else
      name = "episode" .. tostring(LEV.episode.ep_index)
    end

    local opt = self.options[name]

    -- ignore unknown episodes
    if not opt then continue end

    THEME_CONTROL.set_a_theme(LEV, opt)
  end
end


OB_MODULES["theme_ctl_doom2"] =
{
  label = "Doom 2 Theme Control"

  game = { doom2=1 }

  hooks =
  {
    get_levels = THEME_CONTROL.get_levels
  }

  options =
  {
    episode1  = { label="Episode 1",     choices=THEME_CONTROL.CHOICES }
    episode2  = { label="Episode 2",     choices=THEME_CONTROL.CHOICES }
    episode3  = { label="Episode 3",     choices=THEME_CONTROL.CHOICES }
    secret    = { label="Secret Levels", choices=THEME_CONTROL.CHOICES }
  }
}


------------------------------------------------------------------------


THEME_CONTROL.DOOM1_CHOICES =
{
  "no_change", "NO CHANGE"

  "tech",   "Tech"
  "deimos", "Deimos"
  "hell",   "Hell"
  "flesh",  "Flesh"

  "psycho", "Psychedelic"
}


OB_MODULES["theme_ctl_doom1"] =
{
  label = "Doom 1 Theme Control"

  game = { doom1=1 }

  hooks =
  {
    -- using same function for both Doom 1 and Doom 2 modules
    get_levels = THEME_CONTROL.get_levels
  }

  options =
  {
    episode1  = { label="Episode 1",     choices=THEME_CONTROL.DOOM1_CHOICES }
    episode2  = { label="Episode 2",     choices=THEME_CONTROL.DOOM1_CHOICES }
    episode3  = { label="Episode 3",     choices=THEME_CONTROL.DOOM1_CHOICES }
    episode4  = { label="Episode 4",     choices=THEME_CONTROL.DOOM1_CHOICES }
    secret    = { label="Secret Levels", choices=THEME_CONTROL.DOOM1_CHOICES }
  }
}

