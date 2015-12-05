------------------------------------------------------------------------
--  MODULE: Extra Settings
------------------------------------------------------------------------
--
--  Copyright (C) 2014-2015 Andrew Apted
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
  "no",  "No"
  "yes", "Yes"
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
  label = "Extra Settings"
  priority = 90

  hooks =
  {
    setup = EXTRA_SETTINGS.setup
  }

  options =
  {
    pistol_starts =
    {
      label="Pistol Starts"
      choices=EXTRA_SETTINGS.YES_NO
      tooltip="Ensure every map can be completed from a pistol start (i.e. ignore weapons obtained from earlier maps)"
    }

    start_together =
    {
      label="Start Together"
      choices=EXTRA_SETTINGS.YES_NO
      tooltip="For Co-operative games, this makes sure all players start in the same room (i.e. it disables the separated start rooms)"
    }
  }
}

