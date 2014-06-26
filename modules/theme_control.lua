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
  "keep",   "NO CHANGE"
  "tech",   "Tech"
  "urban",  "Urban"
  "hell",   "Hell"
  "wolf",   "Wolfenstein"
  "egypt",  "Egypt (TNT)"
}


function THEME_CONTROL.get_levels(self)
  -- FIXME !!!
  for name,opt in pairs(self.options) do
    local blah = self.options[name].value
  end
end


OB_MODULES["theme_control"] =
{
  label = "Doom Theme Control"

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

