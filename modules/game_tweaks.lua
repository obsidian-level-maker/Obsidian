------------------------------------------------------------------------
--  MODULE: Gameplay Tweaks
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

GAMEPLAY_TWEAKS = {}


GAMEPLAY_TWEAKS.YES_NO =
{
  "no",  "No"
  "yes", "Yes"
}


function GAMEPLAY_TWEAKS.setup(self)
  for name,opt in pairs(self.options) do
    local value = self.options[name].value

    if value == "no" or value == "none" then
      -- ignore it
    else
      PARAM[name] = value
    end
  end
end


OB_MODULES["gameplay_tweaks"] =
{
  label = "Gameplay Tweaks"

  hooks =
  {
    setup = GAMEPLAY_TWEAKS.setup
  }

  options =
  {
    keep_weapons =
    {
      label="Keep Weapons"
      choices=GAMEPLAY_TWEAKS.YES_NO
      tooltip="Assumes the player keeps weapons from previous maps (and will add ammo for them, even if this map does not contain those weapons)"
    }

    quiet_start =
    {
      label="Quiet Start"
      choices=GAMEPLAY_TWEAKS.YES_NO
      tooltip="Never add any monsters into the start room"
    }

    start_together =
    {
      label="Start Together"
      choices=GAMEPLAY_TWEAKS.YES_NO
      tooltip="For Co-operative games, this makes sure all players start in the same room (i.e. it disables the separated start rooms)"
    }
  }
}

