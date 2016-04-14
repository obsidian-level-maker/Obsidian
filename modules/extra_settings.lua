------------------------------------------------------------------------
--  MODULE: Extra Settings
------------------------------------------------------------------------
--
--  Copyright (C) 2014-2016 Andrew Apted
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

EXTRA_SETTINGS = {}


EXTRA_SETTINGS.YES_NO =
{
  "no",  _("No"),
  "yes", _("Yes"),
}


function EXTRA_SETTINGS.setup(self)
  for name,opt in pairs(self.options) do
    local value = self.options[name].value

    if value == "no" or value == "none" then
      -- ignore it
    else
      PARAM[name] = value
    end
  end
end


OB_MODULES["extra_settings"] =
{
  label = _("Extra Settings")
  priority = 90

  hooks =
  {
    setup = EXTRA_SETTINGS.setup
  }

  options =
  {
    pistol_starts =
    {
      label=_("Pistol Starts")
      choices=EXTRA_SETTINGS.YES_NO
      tooltip=_("Ensure every map can be completed from a pistol start (ignore weapons obtained from earlier maps)")
    }

    start_together =
    {
      label=_("Start Together")
      choices=EXTRA_SETTINGS.YES_NO
      tooltip=_("For Co-operative games, ensure all players start in the same room (disable the separated start rooms)")
    }
  }
}

